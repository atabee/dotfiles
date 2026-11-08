"""Homebrew本体の移行でパッケージを保持し、失敗時に参照を復元することを検証する。"""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('homebrew_migration', ROOT / 'scripts/migrate-homebrew-from-nix.py')
MIGRATION = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MIGRATION)


class HomebrewMigrationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='homebrew-migration-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.prefix = self.root / 'prefix'
        self.source = self.root / 'source'
        self.backup = self.root / 'backup'
        for path in ['bin', 'Library', 'Cellar/example/1.0', 'Caskroom/example/1.0']:
            (self.prefix / path).mkdir(parents=True, exist_ok=True)
        self.links = {'bin/brew': '/nix/store/example-brew',
                      'Library/Homebrew': '/nix/store/example-library/Library/Homebrew'}
        for path, target in self.links.items():
            (self.prefix / path).symlink_to(target)
        for path in ['Cellar/example/1.0/keep', 'Caskroom/example/1.0/keep']:
            (self.prefix / path).write_text('installed-package\n')
        (self.prefix / 'Library/.homebrew-is-managed-by-nix').mkdir()
        self.source.mkdir()
        for path in ['bin/brew', 'Library/Homebrew/brew.sh']:
            target = self.source / path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text('official-program\n')
        env = dict(os.environ, HOME=str(self.root))
        subprocess.run(['/usr/bin/git', 'init', str(self.source)], check=True, capture_output=True, env=env)
        subprocess.run(['/usr/bin/git', '-C', str(self.source), 'add', '.'], check=True, capture_output=True, env=env)

    def assert_packages_preserved(self):
        for path in ['Cellar/example/1.0/keep', 'Caskroom/example/1.0/keep']:
            self.assertEqual((self.prefix / path).read_text(), 'installed-package\n')

    def test_replaces_only_program_and_preserves_packages(self):
        MIGRATION.migrate(self.prefix, self.source, self.backup)
        self.assert_packages_preserved()
        self.assertEqual((self.prefix / 'bin/brew').read_text(), 'official-program\n')
        self.assertFalse((self.prefix / 'bin/brew').is_symlink())
        self.assertTrue((self.prefix / '.git').is_dir())
        for path, target in self.links.items():
            self.assertEqual(os.readlink(self.backup / path), target)
        self.assertTrue((self.backup / 'managed-marker').is_dir())

    def test_existing_checkout_is_not_overwritten(self):
        (self.prefix / '.git').mkdir()
        with self.assertRaises(RuntimeError):
            MIGRATION.migrate(self.prefix, self.source, self.backup)
        self.assert_packages_preserved()
        for path, target in self.links.items():
            self.assertEqual(os.readlink(self.prefix / path), target)

    def test_copy_failure_restores_original_references(self):
        with mock.patch.object(MIGRATION.shutil, 'copytree', side_effect=OSError('copy failed')):
            with self.assertRaises(OSError):
                MIGRATION.migrate(self.prefix, self.source, self.backup)
        self.assert_packages_preserved()
        for path, target in self.links.items():
            self.assertEqual(os.readlink(self.prefix / path), target)
        self.assertFalse((self.prefix / '.git').exists())


if __name__ == '__main__':
    unittest.main()
