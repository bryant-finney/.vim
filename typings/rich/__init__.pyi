"""Type stubs for rich module.

Rich is a Python library for rich text and beautiful formatting in the terminal.
"""

from __future__ import annotations

from typing import Any

def print(
    *objects: Any,
    sep: str = ' ',
    end: str = '\n',
    file: Any = None,
    flush: bool = False,
) -> None:
    """Print with rich text formatting support.

    Args:
        *objects: Objects to print, which can include Rich renderables or markup strings.
        sep: String inserted between values.
        end: String appended after the last value.
        file: A file-like object; defaults to the current sys.stdout.
        flush: Whether to forcibly flush the stream.
    """
    ...
