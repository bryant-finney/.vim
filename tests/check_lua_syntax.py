#!/usr/bin/env -S uv run --script
# https://docs.astral.sh/uv/guides/scripts/#using-a-shebang-to-create-an-executable-file
# /// script
# requires-python = ">=3.10"
# dependencies = ["rich", "sh"]
# ///
"""Helper script for invoking `luac` on all `*.lua` files."""

import sys

import rich
import sh


def git_listfiles(pattern: str) -> list[str]:
    """List files in git repository matching the given pattern."""
    result = sh.git('ls-files', pattern)
    return [f.strip() for f in str(result).strip().split('\n') if f.strip()]


def check_lua_syntax() -> int:
    """Check syntax of all Lua files in the git repository."""
    errors: list[tuple[str, sh.ErrorReturnCode]] = []
    files = git_listfiles('**/*.lua')

    for file in files:
        try:
            sh.luac('-p', file)
        except sh.CommandNotFound:
            return 1
        except sh.ErrorReturnCode as exc:
            errors.append((file, exc))

    if errors:
        rich.print('[red]Lua syntax errors found:[/red]', end=' ')
        rich.print('\n  - '.join([f'[red]{file}[/]: {exc}' for file, exc in errors]))
        return 1

    return 0


if __name__ == '__main__':
    sys.exit(check_lua_syntax())
