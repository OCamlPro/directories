let ( / ) = Filename.concat

module type App_id = sig
  val qualifier : string

  val organization : string

  val application : string
end

(* TODO: remove once we drop 4.07 *)
let option_map f = function
  | None -> None
  | Some v -> Some (f v)

(* TODO: remove once we drop 4.07 *)
let option_bind o f =
  match o with
  | None -> None
  | Some v -> f v

let relative_opt dir =
  if Filename.is_relative dir then
    None
  else
    Some dir

let getenv env =
  match Sys.getenv env with
  | exception Not_found -> None
  | "" -> None
  | v -> Some v

let getenvdir env = option_bind (getenv env) relative_opt

let lower_and_replace_ws s replace =
  let s = String.trim s in
  let buff = Buffer.create (String.length s) in
  let should_replace = ref false in
  for i = 0 to String.length s - 1 do
    match s.[i] with
    | ' '
    | '\012'
    | '\n'
    | '\r'
    | '\t' ->
      if !should_replace then (
        Buffer.add_string buff replace;
        should_replace := false
      )
    | c ->
      Buffer.add_char buff c;
      should_replace := true
  done;
  String.lowercase_ascii (Buffer.contents buff)
