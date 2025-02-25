open Directories_common

module Base_dirs () = struct
  (** $HOME or initial working directory value for the current user (taken from
      user database) *)
  let home_dir =
    match getenvdir "HOME" with
    | None -> (
      match (Unix.getpwuid (Unix.getuid ())).Unix.pw_dir with
      | exception Unix.Unix_error _ -> None
      | exception Not_found -> None
      | dir ->
        let dir = Fpath.of_string dir |> Result.to_option in
        Option.bind dir relative_opt )
    | Some _ as dir -> dir

  (** $HOME/Library/Caches *)
  let cache_dir =
    Option.map (fun dir -> Fpath.(dir / "Library" / "Caches")) home_dir

  (** $HOME/Library/Application Support *)
  let config_dir =
    Option.map
      (fun dir -> Fpath.(dir / "Library" / "Application Support"))
      home_dir

  (** $HOME/Library/Application Support *)
  let data_dir =
    Option.map
      (fun dir -> Fpath.(dir / "Library" / "Application Support"))
      home_dir

  (** $HOME/Library/Application Support *)
  let data_local_dir = data_dir

  (** $HOME/Library/Preferences *)
  let preference_dir =
    Option.map (fun dir -> Fpath.(dir / "Library" / "Preferences")) home_dir

  (** None *)
  let runtime_dir = None

  let state_dir = cache_dir

  (** None *)
  let executable_dir = None
end

module User_dirs () = struct
  module Base_dirs = Base_dirs ()

  (** $HOME or initial working directory value for the current user (taken from
      user database) *)
  let home_dir = Base_dirs.home_dir

  let concat_home_dir suffix =
    Option.map (fun dir -> Fpath.(dir / suffix)) home_dir

  (** $HOME/Music *)
  let audio_dir = concat_home_dir "Music"

  (** $HOME/Desktop *)
  let desktop_dir = concat_home_dir "Desktop"

  (** $HOME/Documents *)
  let document_dir = concat_home_dir "Documents"

  (** $HOME/Downloads *)
  let download_dir = concat_home_dir "Downloads"

  (** $HOME/Library/Fonts *)
  let font_dir =
    let library_dir = concat_home_dir "Library" in
    Option.map (fun dir -> Fpath.(dir / "Fonts")) library_dir

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

  let qualifier = Directories_common.lower_and_replace_ws App_id.qualifier "-"

  let organization =
    Directories_common.lower_and_replace_ws App_id.organization "-"

  let application =
    Directories_common.lower_and_replace_ws App_id.application "-"

  let project_path =
    Format.sprintf "%s.%s.%s" qualifier organization application

  let concat_project_path = Option.map (fun dir -> Fpath.(dir / project_path))

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

  let state_dir = cache_dir

  (** None *)
  let runtime_dir = None
end
