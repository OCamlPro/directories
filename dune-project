(lang dune 2.0)

(name directories)

(generate_opam_files true)

(package
 (name directories)
 (synopsis "Directories")
 (description "directories")
 (depends
  (ocaml
   (>= 4.07.0))
  (ctypes-foreign
   (>= 0.4.0))
  (ctype
   (>= 0.17.1))))

(package
 (name directories_linux)
 (synopsis "Directories")
 (description "directories")
 (depends
  (ocaml
   (>= 4.07.0))))

(package
 (name directories_windows)
 (synopsis "Directories")
 (description "directories")
 (depends
  (ocaml
   (>= 4.07.0))
  (ctypes-foreign
   (>= 0.4.0))
  (ctype
   (>= 0.17.1))))

(package
 (name directories_macos)
 (synopsis "Directories")
 (description "directories")
 (depends
  (ocaml
   (>= 4.07.0))))

(package
 (name directories_common)
 (synopsis "Directories")
 (description "directories")
 (depends
  (ocaml
   (>= 4.07.0))))
