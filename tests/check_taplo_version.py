#!/usr/bin/env -S uv run --script
# https://docs.astral.sh/uv/guides/scripts/#using-a-shebang-to-create-an-executable-file
# /// script
# requires-python = ">=3.10"
# dependencies = ["rich", "sh"]
# ///
"""Helper script for checking the current `taplo` version supports the `lsp` server."""

import sys

import rich
import sh


def check_taplo_version() -> None:
    """Verify the installed taplo version supports execution as an LSP server."""
    taplo_version_out = (
        sh.taplo('--version')
        .strip(
            # trailing newline
        )
        .split(
            # taplo 0.10.0
        )[-1]
    )

    taplo_version = tuple(map(int, taplo_version_out.split('.')))

    if taplo_version < (0, 10, 0):
        rich.print(
            f'[red]Error:[/red] taplo version [violet]{taplo_version_out}[/] does not support LSP server functionality. '
            'Please upgrade to at least version 0.10.0.'
        )
        sys.exit(1)
    rich.print(f'[violet]{taplo_version_out}[/]')


if __name__ == '__main__':
    check_taplo_version()
