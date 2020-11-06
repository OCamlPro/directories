let () =
  (* The windows module *)
  let module M = Directories in

  (* The base dirs module *)
  let module B = M.Base_dirs () in
  (* The user dirs module *)
  let module U = M.User_dirs () in

  (* In order to instanciate the Project_dir functor, we need a module for our project *)
  let module OCamlPro_path = struct
    let qualifier = "com"
    let organization = "OCamlPro"
    let application = "print_dir"
  end in
  (* The project dirs module for our project *)
  let module P = M.Project_dirs (OCamlPro_path) in

  (* functions to print a dir path *)
  let print_dir = function
    | None -> Format.printf "  None@."
    | Some dir -> Format.printf "  Some: %s@." dir
  in
  let print_dirs = List.iter print_dir in

  (* Printing base dirs *)
  Format.printf "Base dirs:@.";
  print_dirs [B.home_dir; B.cache_dir; B.config_dir; B.data_dir; B.data_local_dir; B.preference_dir; B.runtime_dir; B.executable_dir];

  (* Printing user dirs *)
  Format.printf "User dirs:@.";
  print_dirs [U.home_dir; U.audio_dir; U.desktop_dir; U.document_dir; U.download_dir; U.font_dir; U.picture_dir; U.public_dir; U.template_dir; U.video_dir];

  (* Printing project dirs*)
  Format.printf "Project dirs:@.";
  print_dirs [P.cache_dir; P.config_dir; P.data_dir; P.data_local_dir; P.preference_dir; P.runtime_dir]
