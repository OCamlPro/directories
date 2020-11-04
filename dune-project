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
