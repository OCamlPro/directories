# directories [![Actions Status](https://github.com/ocamlpro/directories/workflows/build/badge.svg)](https://github.com/ocamlpro/directories/actions)

directories is an [OCaml] library that provides configuration, cache and data paths (and more!) following the respective conventions on [Linux], [macOS] and [Windows]. It is inspired by similar libraries for other languages such as [directories-jvm].

The following conventions are used:

- [XDG Base Directory Specification] and [xdg-user-dirs] on Linux
- [Known Folders] on Windows
- [Standard Directories] on macOS

On Linux and macOS it has no dependency. On Windows, it depends only on [ctypes].

## About

- [LICENSE]
- [CHANGELOG]

[CHANGELOG]: ./CHANGELOG.md
[LICENSE]: ./LICENSE.md

[ctypes]: https://github.com/ocamllabs/ocaml-ctypes
[directories-jvm]: https://github.com/dirs-dev/directories-jvm
[Known Folders]: https://docs.microsoft.com/fr-fr/windows/win32/shell/known-folders
[Linux]: https://en.wikipedia.org/wiki/Linux
[macOS]: https://en.wikipedia.org/wiki/MacOS
[OCaml]: https://en.wikipedia.org/wiki/OCaml
[Standard Directories]: https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html#//apple_ref/doc/uid/TP40010672-CH2-SW6
[xdg-user-dirs]: https://www.freedesktop.org/wiki/Software/xdg-user-dirs/
[XDG Base Directory Specification]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[Windows]: https://en.wikipedia.org/wiki/Microsoft_Windows
