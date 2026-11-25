#!/usr/bin/env python3
"""nix-homebrewのプログラム部分を公式checkoutに置き換え、導入済みパッケージを保持する。"""
import argparse
import datetime
import os
from pathlib import Path
import shutil
import subprocess
import sys


def migrate(prefix, source, backup):
    links = [prefix / 'bin/brew', prefix / 'Library/Homebrew']
    managed = [p.is_symlink() and os.readlink(p).startswith('/nix/store/') for p in links]
    if not any(managed):
        print('Homebrew本体はNix管理のリンクではありません。変更しません。')
        return
    if not all(managed) or not (prefix / 'Cellar').is_dir():
        raise RuntimeError('想定したnix-homebrewの構成ではありません。変更を停止します。')
    if (prefix / '.git').exists():
        raise RuntimeError('既存のGit管理情報があるため、自動では置き換えません。')
    tracked = subprocess.check_output(['/usr/bin/git', '-C', str(source), 'ls-files', '-z'])
    names = [Path(name.decode()) for name in tracked.split(b'\0') if name]
    required = {Path('bin/brew'), Path('Library/Homebrew/brew.sh')}
    if not required.issubset(set(names)):
        raise RuntimeError('Homebrewのソースが不足しています。')
    backup.mkdir(parents=True, exist_ok=True)
    moved = []
    marker = prefix / 'Library/.homebrew-is-managed-by-nix'
    try:
        for path in links:
            target = backup / path.relative_to(prefix)
            target.parent.mkdir(parents=True, exist_ok=True)
            if target.exists() or target.is_symlink():
                raise RuntimeError('バックアップ先に同名のファイルがあります。')
            path.rename(target)
            moved.append((path, target))
        for relative in names:
            src, dst = source / relative, prefix / relative
            if dst.exists() or dst.is_symlink():
                saved = backup / 'overwritten' / relative
                saved.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(dst, saved, follow_symlinks=False)
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst, follow_symlinks=False)
        shutil.copytree(source / '.git', prefix / '.git', symlinks=True)
        if marker.exists():
            target = backup / 'managed-marker'
            marker.rename(target)
            moved.append((marker, target))
    except Exception:
        # パッケージ領域には触れず、プログラム参照を元に戻す。
        if (prefix / '.git').exists():
            incomplete = backup / 'incomplete'
            incomplete.mkdir(parents=True, exist_ok=True)
            (prefix / '.git').rename(incomplete / '.git')
        for path, saved in reversed(moved):
            if path.exists() or path.is_symlink():
                failed = backup / 'incomplete' / path.relative_to(prefix)
                failed.parent.mkdir(parents=True, exist_ok=True)
                path.rename(failed)
            saved.rename(path)
        raise
    print('Homebrew本体を公式checkoutへ移しました。Cellar/Caskroomは保持しています。')
    print('バックアップ:', backup)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, help='取得済みの公式Homebrew/brew checkout')
    args = parser.parse_args()
    if sys.platform != 'darwin':
        parser.error('macOS専用です。')
    prefix = Path('/opt/homebrew')
    if not any(p.is_symlink() and os.readlink(p).startswith('/nix/store/')
               for p in [prefix / 'bin/brew', prefix / 'Library/Homebrew']):
        print('Homebrew本体はNix管理のリンクではありません。変更しません。')
        return
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    state = Path(os.environ.get('XDG_STATE_HOME', str(Path.home() / '.local/state')))
    backup = state / 'dotfiles' / ('homebrew-migration-' + stamp)
    source = args.source
    if source is None:
        source = backup / 'source'
        source.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(['/usr/bin/git', 'clone', '--depth', '1',
                        'https://github.com/Homebrew/brew.git', str(source)], check=True)
    remote = subprocess.check_output(['/usr/bin/git', '-C', str(source),
                                      'remote', 'get-url', 'origin'], text=True).strip()
    if remote not in {'https://github.com/Homebrew/brew.git', 'https://github.com/Homebrew/brew'}:
        parser.error('公式Homebrew/brewのcheckoutを指定してください。')
    migrate(prefix, source, backup / 'original')


if __name__ == '__main__':
    main()
