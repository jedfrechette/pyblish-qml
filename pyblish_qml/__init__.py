from .version import (
    version,
    version_info,
    __version__
)

import site
from pathlib import Path

site.addsitedir(Path(__file__).parent.joinpath('vendor').as_posix())


def show(parent=None,
         targets=None,
         modal=None,
         foster=None,
         auto_publish=False,
         auto_validate=False):
    from . import host

    if foster is not None:
        print("Foster Mode has been deprecated.")

    if targets is None:
        targets = []
    return host.show(parent, targets, modal, auto_publish, auto_validate)


_state = {}

__all__ = [
    "__version__",
    "version",
    "show",
    "version_info",
]
