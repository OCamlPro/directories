type os = Linux | MacOS | Windows

let os =
  if Sys.win32 then Windows
  else
    let chan = Unix.open_process_in "uname" in
    let uname = input_line chan in
    let _status = Unix.close_process_in chan in
    (* TODO: check that _status is OK *)
    if String.equal "Darwin" uname then MacOS else Linux

let relative_opt dir = if Filename.is_relative dir then None else Some dir

let getenvdir env =
  match Sys.getenv env with
  | (exception Not_found) | "" ->
      None
  | dir ->
      relative_opt dir

let ( / ) = Filename.concat

(*
let get_dirs env_var unix_default win32_default =
  let default = if Sys.win32 then win32_default else unix_default in
  match Sys.getenv env_var with
  | (exception Not_found) | "" ->
      default
  | dirs ->
      let dirs =
        List.filter
          (fun dir -> not @@ (String.equal dir "" || Filename.is_relative dir))
          (String.split_on_char ':' dirs)
      in
      if dirs = [] then default else dirs

let config_dirs = get_dirs "XDG_CONFIG_DIRS" ["/etc" / "xdg"]

let data_dirs =
  get_dirs "XDG_DATA_DIRS" ["/usr" / "local" / "share"; "/usr" / "share"]
*)
