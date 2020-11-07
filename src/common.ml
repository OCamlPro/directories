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

let relative_opt dir =
  if Filename.is_relative dir then
    None
  else
    Some dir

let getenvdir env =
  match Sys.getenv env with
  | exception Not_found -> None
  | "" -> None
  | dir -> relative_opt dir
