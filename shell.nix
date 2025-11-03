{ pkgs ? import <nixpkgs> { } }:

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;
in
pkgs.mkShell {
  name = "frost";
  dontDetectOcamlConflicts = false;
  nativeBuildInputs = with ocamlPackages; [
    dune_3
    findlib
    merlin
    ocaml
    ocamlformat
    odoc
  ];
  buildInputs = with ocamlPackages; [
    fpath
  ];
}
