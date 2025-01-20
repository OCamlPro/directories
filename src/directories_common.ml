module type App_id = sig
  val qualifier : string

  val organization : string

  val application : string
end

let relative_opt dir = if Fpath.is_rel dir then None else Some dir

let getenv env =
  match Sys.getenv env with
  | exception Not_found -> None
  | "" -> None
  | v -> Some v

let getenvdir env =
  match getenv env with
  | None -> None
  | Some v -> (
    match Fpath.of_string v with Error _ -> None | Ok v -> relative_opt v )

let lower_and_replace_ws s replace =
  let s = String.trim s in
  let buff = Buffer.create (String.length s) in
  let should_replace = ref false in
  for i = 0 to String.length s - 1 do
    match s.[i] with
    | ' ' | '\012' | '\n' | '\r' | '\t' ->
      if !should_replace then (
        Buffer.add_string buff replace;
        should_replace := false )
    | c ->
      Buffer.add_char buff c;
      should_replace := true
  done;
  String.lowercase_ascii (Buffer.contents buff)
