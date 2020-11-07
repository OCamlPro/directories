(lang dune 2.1)

(name directories)

(version 0.1)

(generate_opam_files true)

(license ISC)

(authors "OCamlPro <contact@ocamlpro.com>")

(maintainers "OCamlPro <contact@ocamlpro.com>")

(source
 (github ocamlpro/directories))

(package
 (name directories)
 (synopsis
   "An OCaml library that provides configuration, cache and data paths (and more!) following the suitable conventions on Linux, macOS and Windows")
 (description
   "directories is an OCaml library that provides configuration, cache and data paths (and more!) following the suitable conventions on Linux, macOS and Windows. It is inspired by similar libraries for other languages such as directories-jvm. The following conventions are used: XDG Base Directory Specification and xdg-user-dirs on Linux, Known Folders on Windows, Standard Directories on macOS.")
 (depends
  (ocaml
   (>= 4.07.0))
  (ctypes-foreign
   (or
    (or
     (>= 0.4.0)
     (<> os "win32"))
    (<> os "mingw")))
  (ctypes
   (or
    (or
     (>= 0.17.1)
     (<> os "win32"))
    (<> os "mingw")))))
