let () =
  (* The directories module *)
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
    | None, s -> Format.printf "  %s None@." s
    | Some dir, s -> Format.printf "  %s Some `%a`@." s Fpath.pp dir
  in
  let print_dirs = List.iter print_dir in

  (* Printing base dirs *)
  Format.printf "* Base dirs:@.";
  print_dirs
    [ (B.home_dir, "home_dir:      ")
    ; (B.cache_dir, "cache_dir:     ")
    ; (B.config_dir, "config_dir:    ")
    ; (B.data_dir, "data_dir:      ")
    ; (B.data_local_dir, "data_local_dir:")
    ; (B.preference_dir, "preference_dir:")
    ; (B.runtime_dir, "runtime_dir:   ")
    ; (B.state_dir, "state_dir:     ")
    ; (B.executable_dir, "executable_dir:")
    ];

  (* Printing user dirs *)
  Format.printf "* User dirs:@.";
  print_dirs
    [ (U.home_dir, "home_dir:      ")
    ; (U.audio_dir, "audio_dir:     ")
    ; (U.desktop_dir, "desktop_dir:   ")
    ; (U.document_dir, "document_dir:  ")
    ; (U.download_dir, "download_dir:  ")
    ; (U.font_dir, "font_dir:      ")
    ; (U.picture_dir, "picture_dir:   ")
    ; (U.public_dir, "public_dir:    ")
    ; (U.template_dir, "template_dir:  ")
    ; (U.video_dir, "video_dir:     ")
    ];

  (* Printing project dirs*)
  Format.printf "* Project dirs:@.";
  print_dirs
    [ (P.cache_dir, "cache_dir:     ")
    ; (P.config_dir, "config_dir:    ")
    ; (P.data_dir, "data_dir:      ")
    ; (P.data_local_dir, "data_local_dir:")
    ; (P.preference_dir, "preference_dir:")
    ; (P.state_dir, "state_dir:     ")
    ; (P.runtime_dir, "runtime_dir:   ")
    ]
