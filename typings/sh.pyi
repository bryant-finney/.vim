"""Type stubs for sh module.

The sh module is a dynamic module that provides command execution functionality.
"""

from __future__ import annotations

from typing import Any

class ErrorReturnCode(Exception):  # noqa: N818
    """Base exception for non-zero exit codes."""

    stderr: bytes | str
    stdout: bytes | str
    exit_code: int
    full_cmd: str

class CommandNotFound(Exception):  # noqa: N818
    """Exception raised when a command is not found."""

class RunningCommand:
    """Represents a running or completed command."""

    def __str__(self) -> str: ...
    def __repr__(self) -> str: ...
    def strip(self) -> str: ...
    def split(self, sep: str | None = None) -> list[str]: ...

def git(*args: str | Any, **kwargs: Any) -> RunningCommand:
    """Execute git command."""
    ...

def luac(*args: str | Any, **kwargs: Any) -> RunningCommand:
    """Execute luac command."""
    ...

def taplo(*args: str | Any, **kwargs: Any) -> RunningCommand:
    """Execute taplo command."""
    ...
