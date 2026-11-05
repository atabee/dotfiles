"""旧個人用構成との整合と、安全な初期配置・再適用を隔離環境で検証する。"""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]
CHEZMOI = os.environ.get('CHEZMOI_BIN') or shutil.which('chezmoi')
ZSH = '/bin/zsh' if Path('/bin/zsh').exists() else shutil.which('zsh')
PREVIOUS = json.loads((REPO / 'tests/fixtures/migration-baseline.json').read_text())

STUB = r'''import json, os, pathlib, shlex, sys
name = pathlib.Path(sys.argv[0]).name
args = sys.argv[1:]
prefix = pathlib.Path(os.environ['TEST_BREW_PREFIX'])
with open(os.environ['TEST_COMMAND_LOG'], 'a') as log:
    log.write(json.dumps([name, args, os.getcwd()]) + '\n')
if name == 'brew':
    if args == ['--prefix']:
        print(prefix)
    elif args == ['shellenv']:
        print('export HOMEBREW_PREFIX=' + shlex.quote(str(prefix)))
        print('export PATH=' + shlex.quote(str(prefix / 'bin')) + ':"$PATH"')
    elif args[:2] == ['bundle', 'cleanup'] and '--force' not in args:
        print('Would remove an unlisted package')
        sys.exit(1)
    elif args[:2] == ['bundle', 'install']:
        manifest = pathlib.Path(args[args.index('--file') + 1])
        if not manifest.is_file():
            sys.exit('Brewfile is missing')
elif name == 'sudo':
    os.execvpe(args[0], args, os.environ)
elif name == 'git':
    if args and args[0] == 'clone' and ('zsh' in args[-1] or 'powerlevel10k' in args[-1]):
        (pathlib.Path(args[-1]) / '.git').mkdir(parents=True)
    elif args[:1] == ['-C'] and 'zsh/plugins/' in args[1]:
        pass
    else:
        os.execv('/usr/bin/git', ['git'] + args)
elif name == 'mise':
    if 'which' in args and args[-1] == 'delta':
        print(prefix / 'opt/git-delta/bin/delta')
elif name == 'ghcup':
    if args[:2] == ['whereis', 'ghc']:
        print(prefix / 'bin/ghc')
    elif args[:2] == ['whereis', 'cabal']:
        print(prefix / 'bin/cabal')
elif name == 'cabal':
    if args[:1] == ['install']:
        path = next(a.split('=', 1)[1] for a in args if a.startswith('--installdir='))
        target = pathlib.Path(path) / 'nixfmt'
        target.write_text('#!/bin/sh\nexit 0\n')
        target.chmod(0o755)
elif name == 'herdr':
    installed = pathlib.Path(os.environ['HOME']) / '.plugin-installed'
    if args[:2] == ['plugin', 'list']:
        print('[{"plugin_id":"hunk.diff"}]' if installed.exists() else '[]')
    elif args[:2] == ['plugin', 'install']:
        installed.touch()
elif name == 'delta':
    print(json.dumps(args))
'''


@unittest.skipUnless(CHEZMOI, 'chezmoiが必要です。CHEZMOI_BINでも指定できます。')
class DotfilesMigrationTests(unittest.TestCase):
    def setUp(self):
        # 空白を含むホームでもシェルスクリプトが正しく動くことを確認する。
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles test ')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.home = self.root / 'home'
        self.home.mkdir()
        self.prefix = self.root / 'brew'
        (self.prefix / 'bin').mkdir(parents=True)
        self.log = self.root / 'commands.jsonl'
        self.env = dict(os.environ)
        # 開発端末のmise・direnv・Nix状態を引き継がない。
        for key in list(self.env):
            if key.startswith(('MISE_', 'DIRENV_', 'NIX_', 'XDG_', '__HM_', '__ETC_')) or key == 'ZDOTDIR':
                self.env.pop(key)
        self.env.update({
            'HOME': str(self.home),
            'XDG_CONFIG_HOME': str(self.home / '.config'),
            'XDG_CACHE_HOME': str(self.home / '.cache'),
            'XDG_DATA_HOME': str(self.home / '.local/share'),
            'XDG_STATE_HOME': str(self.home / '.local/state'),
            'HOMEBREW_PREFIX': str(self.prefix),
            'PATH': str(self.prefix / 'bin') + ':/usr/bin:/bin:/usr/sbin:/sbin',
            'TEST_BREW_PREFIX': str(self.prefix),
            'TEST_COMMAND_LOG': str(self.log),
            'SHELL': ZSH or '/bin/sh',
        })
        for name in ['brew', 'mise', 'herdr', 'apt-get', 'sudo', 'git', 'ghcup', 'cabal']:
            self.make_stub(self.prefix / 'bin' / name)
        self.make_stub(self.home / '.local/share/cargo/bin/rustup')
        self.make_stub(self.home / '.local/bin/mise')
        # migrationスクリプトが使うchezmoiも隔離設定で起動する。
        wrapper = self.prefix / 'bin/chezmoi'
        wrapper.write_text('#!/bin/sh\nexec ' + self.quote(str(CHEZMOI)) +
                           ' --config ' + self.quote(str(self.root / 'chezmoi.toml')) +
                           ' --persistent-state ' + self.quote(str(self.root / 'state.db')) +
                           ' --cache ' + self.quote(str(self.root / 'cache')) +
                           ' --destination ' + self.quote(str(self.home)) + ' "$@"\n')
        wrapper.chmod(0o755)
        # Ubuntuの--prepareでもネットワーク経由のインストーラーを起動しない。
        shutil.copy2(wrapper, self.home / '.local/bin/chezmoi')
        self.run_chezmoi('init', source=True)

    @staticmethod
    def quote(value):
        import shlex
        return shlex.quote(value)

    def make_stub(self, path):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text('#!' + sys.executable + '\n' + STUB)
        path.chmod(0o755)

    def run_command(self, args, **kwargs):
        return subprocess.run(args, env=self.env, cwd=str(REPO), check=True,
                              text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, **kwargs)

    def run_chezmoi(self, *args, source=False, override=None):
        command = [str(self.prefix / 'bin/chezmoi'), '--no-tty']
        if source:
            command += ['--source', str(REPO)]
        if override:
            command += ['--override-data', json.dumps({'chezmoi': override})]
        return self.run_command(command + list(args))

    def apply(self, override=None):
        # macOS上でもUbuntu上でも同じ分岐を検証する。
        return self.run_chezmoi('apply', override=override or {'os': 'darwin', 'arch': 'arm64'})

    def calls(self, name=None):
        if not self.log.exists():
            return []
        rows = [json.loads(x) for x in self.log.read_text().splitlines()]
        return [x for x in rows if name is None or x[0] == name]

    def test_packages_and_unmodified_assets(self):
        self.apply(override={'os': 'darwin', 'arch': 'arm64'})
        manifest = (self.home / '.config/dotfiles/Brewfile').read_text()
        casks = re.findall(r'^cask "([^"]+)"', manifest, re.M)
        brews = re.findall(r'^brew "([^"]+)"', manifest, re.M)
        self.assertCountEqual(casks, PREVIOUS['casks'])
        self.assertTrue(set(PREVIOUS['common_commands'] + PREVIOUS['mac_commands']) <= set(brews))
        for target, digest in PREVIOUS['unchanged_files'].items():
            self.assertEqual(hashlib.sha256((self.home / target).read_bytes()).hexdigest(), digest, target)
        settings = json.loads((self.home / '.claude/settings.json').read_text())
        self.assertEqual(settings['permissions'], PREVIOUS['claude_permissions'])
        self.assertCountEqual(settings['enabledPlugins'], PREVIOUS['claude_plugins'])
        self.assertEqual(settings['statusLine']['command'], '~/.claude/statusline.sh')
        calls = self.calls('mise')
        self.assertTrue(any(x[1] == ['use', '--global'] + PREVIOUS['mise_tools'] for x in calls))
        self.assertTrue(all(x[2] == str(self.home) for x in calls))
        self.assertIn('trusted: true', manifest)
        self.assertTrue(os.access(self.home / '.claude/statusline.sh', os.X_OK))
        for file in self.home.rglob('*'):
            self.assertFalse(file.is_symlink(), str(file))

    def test_ubuntu_uses_apt_and_mise_without_homebrew(self):
        (self.prefix / 'bin/brew').unlink()
        self.apply(override={'os': 'linux', 'arch': 'amd64',
                             'osRelease': {'id': 'ubuntu', 'version_id': '24.04'}})
        self.assertFalse((self.home / '.config/dotfiles/Brewfile').exists())
        packages = (self.home / '.config/dotfiles/apt-packages').read_text()
        for package in ['zsh', 'git', 'git-lfs', 'openssh-client', 'direnv', 'tmux', 'trash-cli']:
            self.assertIn(package, packages.splitlines())
        self.assertEqual(self.calls('brew'), [])
        self.assertTrue(any(x[1] == ['update'] for x in self.calls('apt-get')))
        installs = [x[1] for x in self.calls('apt-get') if x[1][:1] == ['install']]
        self.assertEqual(len(installs), 1)
        self.assertIn('silversearcher-ag', installs[0])
        self.assertFalse(any('autoremove' in x[1] for x in self.calls('apt-get')))
        mise_use = next(x[1] for x in self.calls('mise') if x[1][:2] == ['use', '--global'])
        for tool in ['gh', 'ghq', 'fzf', 'fd', 'bat', 'delta', 'ripgrep', 'lazygit', 'go', 'pnpm', 'uv', 'aws-cli']:
            self.assertIn(tool + '@latest', mise_use)
        self.assertTrue(any('nixfmt' in tool for tool in mise_use))
        self.assertTrue(any('leoafarias/fvm' in tool for tool in mise_use))
        self.assertTrue(any('eza-community/eza' in tool for tool in mise_use))
        self.assertIn('/bin/bash', (self.home / '.config/direnv/direnv.toml').read_text())
        self.log.write_text('')
        cli = str(self.home / '.local/bin/dotfiles')
        self.run_command([cli, 'update'])
        self.run_command([cli, 'cleanup'])
        self.assertEqual(self.calls('brew'), [])
        self.assertTrue(any(x[1] == ['--simulate', 'autoremove'] for x in self.calls('apt-get')))
        self.assertFalse(any('--bump' in x[1] for x in self.calls('mise')))
        # deltaもHomebrewのパスを参照しない。
        self.make_stub(self.prefix / 'opt/git-delta/bin/delta')
        result = self.run_command([str(self.home / '.local/bin/delta'), '--paging=never'])
        self.assertEqual(json.loads(result.stdout)[-1], '--paging=never')
        self.assertEqual(self.calls('brew'), [])
        if ZSH:
            self.run_command([ZSH, '-dfc',
                              'OSTYPE=linux-gnu; ZDOTDIR="$HOME/.config/zsh"; '
                              'source "$ZDOTDIR/.zshenv"; source "$ZDOTDIR/.zprofile"; '
                              'source "$ZDOTDIR/.zshrc"'])
            self.assertEqual(self.calls('brew'), [])

    def test_bootstrap_prepare_does_not_apply_configuration(self):
        self.run_command(['/bin/bash', str(REPO / 'scripts/bootstrap.sh'), '--prepare'])
        self.assertFalse((self.home / '.config/dotfiles/Brewfile').exists())
        self.assertFalse(any(x[1][:2] == ['bundle', 'install'] for x in self.calls('brew')))
        self.assertEqual(self.calls('mise'), [])

    def test_ubuntu_arm64_keeps_nixfmt_and_plugin_updates(self):
        self.apply(override={'os': 'linux', 'arch': 'arm64',
                             'osRelease': {'id': 'ubuntu', 'version_id': '24.04'}})
        self.assertEqual(self.calls('brew'), [])
        packages = (self.home / '.config/dotfiles/apt-packages').read_text()
        self.assertIn('libgmp-dev', packages)
        self.assertTrue((self.home / '.local/share/dotfiles/bin/nixfmt').is_file())
        self.assertTrue(any(x[1][:2] == ['install', 'nixfmt'] for x in self.calls('cabal')))
        self.assertTrue(any(x[1][:1] == ['clone'] for x in self.calls('git')))
        self.run_command([str(self.home / '.local/bin/dotfiles'), 'install'])
        # インストール済みのソースビルドとcloneを繰り返さない。
        self.assertEqual(len([x for x in self.calls('cabal') if x[1][:1] == ['install']]), 1)
        self.assertEqual(len([x for x in self.calls('git') if x[1][:1] == ['clone']]), 2)

    def test_unsupported_linux_is_rejected_before_package_changes(self):
        with self.assertRaises(subprocess.CalledProcessError):
            self.apply(override={'os': 'linux', 'arch': 'amd64', 'osRelease': {'id': 'fedora'}})
        self.assertEqual(self.calls('brew'), [])
        self.assertEqual(self.calls('apt-get'), [])

    def test_mutable_app_and_private_configs_survive_reapplication(self):
        files = {
            '.claude/settings.json': '{"custom": true}\n',
            '.config/herdr/config.toml': 'onboarding = true\n',
            '.config/git/.gitconfig.local': '[user]\nname = Local User\n',
            '.config/zsh/local.zsh': 'export LOCAL_SENTINEL=kept\n',
            '.config/mise/config.toml': '[tools]\nruby = "3.4.8"\n',
        }
        for relative, content in files.items():
            path = self.home / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content)
        self.apply()
        self.apply()
        for relative, content in files.items():
            self.assertEqual((self.home / relative).read_text(), content)
        self.run_chezmoi('verify', '--exclude', 'scripts')
        self.assertEqual(len([x for x in self.calls('herdr') if x[1][:2] == ['plugin', 'install']]), 1)
        self.assertTrue(any(x[1] == ['prune', '--yes'] for x in self.calls('mise')))
        self.assertTrue(any(x[1] == ['update'] for x in self.calls('brew')))
        self.assertTrue(any('--zap' in x[1] and '--force' in x[1] for x in self.calls('brew')))
        config = (self.root / 'chezmoi.toml').read_text()
        self.assertIn(str(REPO), config)
        self.assertNotIn(str(REPO / 'home') + '"', config)

    def test_update_and_cleanup_scope(self):
        self.apply()
        self.log.write_text('')
        cli = str(self.home / '.local/bin/dotfiles')
        self.run_command([cli, 'update'])
        self.assertTrue(any(x[1] == ['update'] for x in self.calls('brew')))
        installs = [x for x in self.calls('brew') if x[1][:2] == ['bundle', 'install']]
        self.assertEqual(len(installs), 1)
        self.assertIn(str(self.home / '.config/dotfiles/Brewfile'), installs[0][1])
        self.assertFalse(any('--bump' in x[1] for x in self.calls('mise')))
        self.assertTrue(all(x[2] == str(self.home) for x in self.calls('mise')))
        self.log.write_text('')
        self.run_command([cli, 'cleanup'])
        self.assertTrue(any(x[1] == ['prune', '--dry-run'] for x in self.calls('mise')))
        self.assertFalse(any('--force' in x[1] for x in self.calls()))
        self.run_command([cli, 'cleanup', '--force'])
        self.assertTrue(any('--force' in x[1] for x in self.calls('brew')))
        self.assertTrue(any(x[1] == ['prune', '--yes'] for x in self.calls('mise')))

    def test_delta_preserves_options_for_external_callers(self):
        self.apply()
        self.make_stub(self.prefix / 'opt/git-delta/bin/delta')
        result = self.run_command([str(self.home / '.local/bin/delta'), '--paging=never'])
        self.assertEqual(json.loads(result.stdout),
                         ['--config', str(self.home / '.config/delta/config'), '--paging=never'])
        self.assertIn('side-by-side = true', (self.home / '.config/delta/config').read_text())

    def test_migration_previews_and_backs_up_only_managed_links(self):
        config = self.home / '.config'
        (config / 'git').mkdir(parents=True)
        (config / 'git/config').symlink_to('/nix/store/dotfiles-test-missing/config')
        private = config / 'git/.gitconfig.local'
        private.write_text('private local config\n')
        unmanaged = self.home / 'unmanaged-link'
        unmanaged.symlink_to('/nix/store/unmanaged-test/config')
        command = ['/bin/bash', str(REPO / 'scripts/migrate-from-nix.sh')]
        preview = self.run_command(command + ['--dry-run'])
        self.assertIn('.config/git/config', preview.stdout)
        self.assertTrue((config / 'git/config').is_symlink())
        self.run_command(command + ['--apply'])
        self.assertFalse((config / 'git/config').is_symlink())
        self.assertEqual(private.read_text(), 'private local config\n')
        self.assertTrue(unmanaged.is_symlink())
        backups = [path / '.config/git/config'
                   for path in (self.home / '.local/state/dotfiles').glob('nix-backup-*')]
        self.assertEqual(len(backups), 1)
        self.assertTrue(backups[0].is_symlink())
        self.apply()
        self.assertTrue((config / 'git/config').is_file())

    @unittest.skipUnless(ZSH, 'Zshが必要です。')
    def test_shell_and_git_configuration(self):
        self.apply()
        for relative in ['.zshenv', '.config/zsh/.zshenv', '.config/zsh/.zprofile', '.config/zsh/.zshrc']:
            self.run_command([ZSH, '-n', str(self.home / relative)])
        result = self.run_command([ZSH, '-dlic',
                                   'print -r -- "$ANDROID_HOME|$NDK_HOME|$GOPATH|$GEM_HOME|$HISTSIZE"; '
                                   'alias ls rm; print -r -- ${options[sharehistory]}'])
        self.assertIn(str(self.home / 'Library/Android/sdk/ndk/26.1.10909125'), result.stdout)
        self.assertIn('|100000', result.stdout)
        self.assertIn("rm=trash-put", result.stdout)
        self.assertIn('\non\n', result.stdout)
        git_config = self.home / '.config/git/config'
        result = self.run_command(['/usr/bin/git', 'config', '--file', str(git_config), '--get', 'core.autocrlf'])
        self.assertEqual(result.stdout.strip(), 'input')
        result = self.run_command(['/usr/bin/git', 'config', '--file', str(git_config), '--includes',
                                   '--get', 'delta.side-by-side'])
        self.assertEqual(result.stdout.strip(), 'true')
        self.assertNotIn('/nix/store/', git_config.read_text())


class SourceTests(unittest.TestCase):
    def test_scripts_parse_and_no_dotfiles_nix_build_remains(self):
        paths = list((REPO / 'scripts').glob('*.sh'))
        paths += list((REPO / 'home/dot_local/bin').glob('executable_*'))
        paths += [REPO / 'home/dot_claude/executable_statusline.sh']
        for path in paths:
            subprocess.run(['/bin/bash', '-n', str(path)], check=True, capture_output=True)
        self.assertFalse((REPO / 'nix').exists())
        self.assertFalse((REPO / 'flake.nix').exists())
        self.assertFalse((REPO / 'flake.lock').exists())
        self.assertEqual(hashlib.sha256((REPO / 'home/dot_config/direnv/lib/nix-direnv.sh').read_bytes()).hexdigest(),
                         'c8c276395333ac56833e7eeaf27081645458a4bfdfd11707ce19b0fe2e9bb493')


if __name__ == '__main__':
    unittest.main()
