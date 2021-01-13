
let print_defines fmt =
  List.iter (fun (d, v) -> Format.fprintf fmt "#define %s (%s)@\n" d v)

let print_headers fmt =
  List.iter (Format.fprintf fmt "#include <%s>@\n")

let make_functions_stubs
    (c_defines : (string * string) list)
    (c_headers : string list)
    (functions_functor : (module Cstubs.BINDINGS)) =
  let fmt = Format.std_formatter in
  begin
    match Sys.argv.(1) with
    | "c" ->
		print_defines fmt c_defines;
        print_headers fmt c_headers;
        Cstubs.write_c ~prefix:"win_stub" fmt functions_functor
    | "ml" ->
        Cstubs.write_ml ~prefix:"win_stub" fmt functions_functor
    | s -> failwith ("unknown functions " ^ s)
  end;
  Format.pp_print_flush fmt ()

let () =
  make_functions_stubs
    [ "NTDDI_VERSION", "NTDDI_VISTA" ]
    [ "windows.h"; "shlobj.h" ]
    (module Win_functions_functor.Apply)
