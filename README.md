# directories [![Actions Status](https://github.com/ocamlpro/directories/workflows/build/badge.svg)](https://github.com/ocamlpro/directories/actions)

directories is an [OCaml] library that provides configuration, cache and data paths (and more!) following the suitable conventions on [Linux], [macOS] and [Windows]. It is inspired by similar libraries for other languages such as [directories-jvm].

The following conventions are used:

- [XDG Base Directory Specification] and [xdg-user-dirs] on Linux
- [Known Folders] on Windows
- [Standard Directories] on macOS

It only depends on [fpath]. On Windows, it also has a build-dependency on [ctypes].

## Quickstart

You should depend on `directories` then :

```ocaml
let () =
  let module App_id = struct
    let qualifier = "com"
    let organization = "YourCompany"
    let application = "yourapp"
  end in
  let module M = Directories.Project_dirs (App_id) in
  let option_value = function None -> "None" | Some v -> v in
  Format.printf "cache dir  = `%s`@." (option_value M.cache_dir);
  Format.printf "config dir = `%s`@." (option_value M.config_dir);
  Format.printf "data dir   = `%s`@." (option_value M.data_dir)
```

For more, have a look at the [example] folder.

## About

- [LICENSE]
- [CHANGELOG]

[CHANGELOG]: ./CHANGES.md
[example]: ./example/
[LICENSE]: ./LICENSE.md

[ctypes]: https://github.com/ocamllabs/ocaml-ctypes
[directories-jvm]: https://github.com/dirs-dev/directories-jvm
[fpath]: https://erratique.ch/software/fpath
[Known Folders]: https://docs.microsoft.com/fr-fr/windows/win32/shell/known-folders
[Linux]: https://en.wikipedia.org/wiki/Linux
[macOS]: https://en.wikipedia.org/wiki/MacOS
[OCaml]: https://en.wikipedia.org/wiki/OCaml
[Standard Directories]: https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html#//apple_ref/doc/uid/TP40010672-CH2-SW6
[xdg-user-dirs]: https://www.freedesktop.org/wiki/Software/xdg-user-dirs
[XDG Base Directory Specification]: https://specifications.freedesktop.org/basedir/latest
[Windows]: https://en.wikipedia.org/wiki/Microsoft_Windows
