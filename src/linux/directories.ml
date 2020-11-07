open Common

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

  (** $XDG_CACHE_HOME or $HOME/.cache *)
  let cache_dir =
    match getenvdir "XDG_CACHE_HOME" with
    | None -> option_map (fun dir -> dir / ".cache") home_dir
    | Some _dir as dir -> dir

  (** $XDG_CONFIG_HOME or $HOME/.config *)
  let config_dir =
    match getenvdir "XDG_CONFIG_DIR" with
    | None -> option_map (fun dir -> dir / ".config") home_dir
    | Some _dir as dir -> dir

  (** $XDG_DATA_HOME or $HOME/.local/share *)
  let data_dir =
    match getenvdir "XDG_DATA_DIR" with
    | None -> option_map (fun dir -> dir / ".local" / "share") home_dir
    | Some _dir as dir -> dir

  (** $XDG_DATA_HOME or $HOME/.local/share *)
  let data_local_dir = data_dir

  (** $XDG_CONFIG_HOME or $HOME/.config *)
  let preference_dir = config_dir

  (** $XDG_RUNTIME_DIR *)
  let runtime_dir = getenvdir "XDG_RUNTIME_DIR"

  (** $XDG_BIN_HOME or $XDG_DATA_HOME/../bin or $HOME/.local/bin *)
  let executable_dir =
    match getenvdir "XDG_BIN_HOME" with
    | None -> (
      match getenvdir "XDG_DATA_HOME" with
      | None -> option_map (fun dir -> dir / ".local" / "bin") home_dir
      | Some dir -> Some (dir / ".." / "bin") )
    | Some _dir as dir -> dir
end

module User_dirs () = struct
  module Base_dirs = Base_dirs ()

  (** $HOME or initial working directory value for the current user (taken from
      user database) *)
  let home_dir = Base_dirs.home_dir

  let user_dirs =
    option_map (fun dir -> dir / "user-dirs.dirs") Base_dirs.config_dir

  let user_dirs =
    option_bind user_dirs (fun f ->
        if Sys.file_exists f then
          Some f
        else
          None)

  let user_dirs =
    option_bind user_dirs (fun f ->
        if Sys.is_directory f then
          None
        else
          Some f)

  let user_shell = getenv "SHELL"

  let get_user_dir dir =
    match (user_shell, user_dirs) with
    | Some sh, Some f -> (
      try
        let chan =
          Unix.open_process_in
            (Format.sprintf "%s -c '. %s && echo \"$XDG_%s_DIR\"'" sh f dir)
        in
        let xdg = input_line chan in
        let result = Unix.close_process_in chan in
        match result with
        | WEXITED 0 -> Some xdg
        | _ -> None
      with _ -> None )
    | _ -> None

  let get_user_dir (env, default) =
    match get_user_dir env with
    | Some v -> Some v
    | None -> option_map (fun dir -> dir / default) home_dir

  (** Defaults can be found here
      https://cgit.freedesktop.org/xdg/xdg-user-dirs/tree/user-dirs.defaults *)

  (** $XDG_MUSIC_DIR *)
  let audio_dir = get_user_dir ("MUSIC", "Music")

  (** $XDG_DESKTOP_DIR *)
  let desktop_dir = get_user_dir ("DESKTOP", "Desktop")

  (** $XDG_DOCUMENTS_DIR *)
  let document_dir = get_user_dir ("DOCUMENTS", "Documents")

  (** $XDG_DOWNLOAD_DIR *)
  let download_dir = get_user_dir ("DOWNLOAD", "Downloads")

  (** $XDG_DATA_HOME/fonts or $HOME/.local/share/fonts *)
  let font_dir =
    match getenvdir "XDG_DATA_HOME" with
    | None ->
      option_map (fun dir -> dir / ".local" / "share" / "fonts") home_dir
    | Some dir -> Some (dir / "fonts")

  (** $XDG_PICTURES_DIR *)
  let picture_dir = get_user_dir ("PICTURES", "Pictures")

  (** $XDG_PUBLIC_DIR *)
  let public_dir = get_user_dir ("PUBLICSHARE", "Public")

  (** $XDG_TEMPLATES_DIR *)
  let template_dir = get_user_dir ("TEMPLATES", "Templates")

  (** $XDG_VIDEOS_DIR *)
  let video_dir = get_user_dir ("VIDEOS", "Videos")
end

module Project_dirs (App_id : App_id) = struct
  module Base_dirs = Base_dirs ()

  let project_path = Common.lower_and_replace_ws App_id.application ""

  let concat_project_path = option_map (fun dir -> dir / project_path)

  (** $XDG_CACHE_HOME/<project_path> or $HOME/.cache/<project_path> *)
  let cache_dir = concat_project_path Base_dirs.cache_dir

  (** $XDG_CONFIG_HOME/<project_path> or $HOME/.config/<project_path> *)
  let config_dir = concat_project_path Base_dirs.config_dir

  (** $XDG_DATA_HOME/<project_path> or $HOME/.local/share/<project_path> *)
  let data_dir = concat_project_path Base_dirs.data_dir

  (** $XDG_DATA_HOME/<project_path> or $HOME/.local/share/<project_path> *)
  let data_local_dir = data_dir

  (** $XDG_CONFIG_HOME/<project_path> or $HOME/.config/<project_path> *)
  let preference_dir = config_dir

  (** $XDG_RUNTIME_DIR/<project_path> *)
  let runtime_dir = concat_project_path Base_dirs.runtime_dir
end
