module Base_dirs () = struct
  (** $HOME or initial working directory value for the current user (taken from
      user database) *)
  let home_dir =
    match getenvdir "HOME" with
    | None -> (
      match (Unix.getpwuid (Unix.getuid ())).Unix.pw_dir with
      | exception Unix.Unix_error _ -> None
      | exception Not_found -> None
      | dir -> relative_opt dir )
    | Some _dir as dir -> dir

  (** $HOME/Library/Caches *)
  let cache_dir = option_map (fun dir -> dir / "Library" / "Caches") home_dir

  (** $HOME/Library/Application Support *)
  let config_dir =
    option_map (fun dir -> dir / "Library" / "Application Support") home_dir

  (** $HOME/Library/Application Support *)
  let data_dir =
    option_map (fun dir -> dir / "Library" / "Application Support") home_dir

  (** $HOME/Library/Application Support *)
  let data_local_dir = data_dir

  (** $HOME/Library/Preferences *)
  let preference_dir =
    option_map (fun dir -> dir / "Library" / "Preferences") home_dir

  (** None *)
  let runtime_dir = None

  (** None *)
  let executable_dir = None
end

module User_dirs () = struct
  module Base_dirs = Base_dirs ()

  (** $HOME or initial working directory value for the current user (taken from
      user database) *)
  let home_dir = Base_dirs.home_dir

  let concat_home_dir suffix = option_map (fun dir -> dir / suffix) home_dir

  (** $HOME/Music *)
  let audio_dir = concat_home_dir "Music"

  (** $HOME/Desktop *)
  let desktop_dir = concat_home_dir "Desktop"

  (** $HOME/Documents *)
  let document_dir = concat_home_dir "Documents"

  (** $HOME/Downloads *)
  let download_dir = concat_home_dir "Downloads"

  (** $HOME/Library/Fonts *)
  let font_dir = concat_home_dir ("Library" / "Fonts")

  (** $HOME/Pictures *)
  let picture_dir = concat_home_dir "Pictures"

  (** $HOME/Public *)
  let public_dir = concat_home_dir "Public"

  (** None *)
  let template_dir = None

  (** $HOME/Movies *)
  let video_dir = concat_home_dir "Movies"
end

module Project_dirs (App_id : App_id) = struct
  module Base_dirs = Base_dirs ()

  (* TODO: check that the string is valid and format it correctly *)
  let project_path =
    let open App_id in
    Format.sprintf "%s.%s.%s" qualifier organization application

  let concat_project_path = option_map (fun dir -> dir / project_path)

  (** $HOME/Libary/Caches/<project_path> *)
  let cache_dir = concat_project_path Base_dirs.cache_dir

  (** $HOME/Library/Application Support/<project_path> *)
  let config_dir = concat_project_path Base_dirs.config_dir

  (** $HOME/Library/Application Support/<project_path> *)
  let data_dir = concat_project_path Base_dirs.data_dir

  (** $HOME/Library/Application Support/<project_path> *)
  let data_local_dir = data_dir

  (** $HOME/Library/Preferences/<project_path> *)
  let preference_dir = concat_project_path Base_dirs.preference_dir

  (** None *)
  let runtime_dir = None
end
