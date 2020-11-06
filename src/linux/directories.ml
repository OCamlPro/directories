let relative_opt dir = if Filename.is_relative dir then None else Some dir

let getenvdir env =
  match Sys.getenv env with
  | (exception Not_found) | "" ->
      None
  | dir ->
      relative_opt dir

let (/) = Filename.concat

module Base_dirs () = struct

  (** $HOME or initial working directory value for the current user (taken from user database) *)
  let home_dir =
    match getenvdir "HOME" with
    | None -> (
        match (Unix.getpwuid (Unix.getuid ())).Unix.pw_dir with
      | (exception Unix.Unix_error _) | (exception Not_found) ->
          None
      | dir ->
          relative_opt dir )
    | Some _dir as dir ->
        dir

  (** $XDG_CACHE_HOME or $HOME/.cache *)
  let cache_dir =
    match getenvdir "XDG_CACHE_HOME" with
    | None ->
        Option.map (fun dir -> dir / ".cache") home_dir
    | Some _dir as dir ->
        dir

  (** $XDG_CONFIG_HOME or $HOME/.config *)
  let config_dir =
    match getenvdir "XDG_CONFIG_DIR" with
    | None ->
        Option.map (fun dir -> dir / ".config") home_dir
    | Some _dir as dir ->
        dir

  (** $XDG_DATA_HOME or $HOME/.local/share *)
  let data_dir =
    match getenvdir "XDG_DATA_DIR" with
    | None ->
        Option.map (fun dir -> dir / ".local" / "share") home_dir
    | Some _dir as dir ->
        dir

  (** $XDG_DATA_HOME or $HOME/.local/share *)
  let data_local_dir = data_dir

  (** $XDG_CONFIG_HOME or $HOME/.config *)
  let preference_dir = config_dir

  (** $XDG_RUNTIME_DIR *)
  let runtime_dir = getenvdir "XDG_RUNTIME_DIR"

  (** $XDG_BIN_HOME or $XDG_DATA_HOME/../bin or $HOME/.local/bin *)
  let executable_dir =
    match getenvdir "XDG_BIN_HOME" with
    | None ->
        begin match getenvdir "XDG_DATA_HOME" with
        | None -> Option.map (fun dir -> dir / ".local" / "bin") home_dir
        | Some dir -> Some (dir / ".." / "bin")
        end
    | Some _dir as dir ->
        dir
end

module User_dirs () = struct

  module Base_dirs = Base_dirs ()

  (** $HOME or initial working directory value for the current user (taken from user database) *)
  let home_dir = Base_dirs.home_dir

  (** $XDG_MUSIC_DIR *)
  let audio_dir = getenvdir "XDG_MUSIC_DIR"

  (** $XDG_DESKTOP_DIR *)
  let desktop_dir = getenvdir "XDG_DESKTOP_DIR"

  (** $XDG_DOCUMENTS_DIR *)
  let document_dir = getenvdir "XDG_DOCUMENTS_DIR"

  (** $XDG_DOWNLOAD_DIR *)
  let download_dir = getenvdir "XDG_DOWNLOAD_DIR"

  (** $XDG_DATA_HOME/fonts or $HOME/.local/share/fonts *)
  let font_dir =
    match getenvdir "XDG_DATA_HOME" with
    | None -> Option.map (fun dir -> dir / ".local" / "share" / "fonts") home_dir
    | Some dir -> Some (dir / "fonts")

  (** $XDG_PICTURES_DIR *)
  let picture_dir = getenvdir "XDG_PICTURES_DIR"

  (** $XDG_PUBLIC_DIR *)
  let public_dir = getenvdir "XDG_PUBLICSHARE_DIR"

  (** $XDG_TEMPLATES_DIR *)
  let template_dir = getenvdir "XDG_TEMPLATES_DIR"

  (** $XDG_VIDEOS_DIR *)
  let video_dir = getenvdir "XDG_VIDEOS_DIR"
end

module type Project_path = sig
  val qualifier : string
  val organization : string
  val application : string
end

module Project_dirs (Project_path : Project_path) = struct

  module Base_dirs = Base_dirs ()

  (* TODO: check that the string is valid and format it correctly *)
  let project_path = Project_path.application

  let concat_project_path = Option.map (fun dir -> dir / project_path)

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
