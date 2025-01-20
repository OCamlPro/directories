open Ctypes
open Directories_common
open Win_types
open Win_functions

let wstring_to_string wstr =
  let path_len =
    Kernel32.wide_char_to_multi_byte 65001l 0l wstr (-1l) LPSTR.null 0l
      LPCH.null LPBOOL.null
  in
  let path = allocate_n CHAR.t ~count:(Int32.to_int path_len) in
  let _ =
    Kernel32.wide_char_to_multi_byte 65001l 0l wstr (-1l) path path_len
      LPCH.null LPBOOL.null
  in
  coerce LPSTR.t string path

let get_folderid id =
  let wpath_ptr = allocate PWSTR.t PWSTR.null in
  let result =
    Shell32.sh_get_known_folder_path
      (addr (GUID.to_guid id))
      Known_folder_flag.Default Token.Current_user wpath_ptr
  in
  match result with
  | S_ok ->
    let s = wstring_to_string !@wpath_ptr in
    Fpath.of_string s |> Result.to_option
  | _err -> None

module Base_dirs () = struct
  (** `FOLDERID_UserProfile` *)
  let home_dir : Fpath.t option = get_folderid GUID.UserProfile

  (** `FOLDERID_LocalApplicationData` *)
  let cache_dir = get_folderid GUID.LocalApplicationData

  (** `FOLDERID_ApplicationData` *)
  let config_dir = get_folderid GUID.ApplicationData

  (** `FOLDERID_ApplicationData` *)
  let data_dir = get_folderid GUID.ApplicationData

  (** `FOLDERID_LocalApplicationData` *)
  let data_local_dir = get_folderid GUID.LocalApplicationData

  (** `FOLDERID_ApplicationData` *)
  let preference_dir = get_folderid GUID.ApplicationData

  (** None *)
  let runtime_dir = None

  let state_dir = cache_dir

  (** None *)
  let executable_dir = None
end

module User_dirs () = struct
  module Base_dirs = Base_dirs ()

  (** `FOLDERID_UserProfile` *)
  let home_dir = Base_dirs.home_dir

  (** `FOLDERID_Music` *)
  let audio_dir = get_folderid GUID.Music

  (** `FOLDERID_Desktop` *)
  let desktop_dir = get_folderid GUID.Desktop

  (** `FOLDERID_Documents` *)
  let document_dir = get_folderid GUID.Documents

  (** `FOLDERID_Downloads` *)
  let download_dir = get_folderid GUID.Downloads

  (** None *)
  let font_dir = None

  (** `FOLDERID_Pictures` *)
  let picture_dir = get_folderid GUID.Pictures

  (** `FOLDERID_Public` *)
  let public_dir = get_folderid GUID.Public

  (** `FOLDERID_Templates` *)
  let template_dir = get_folderid GUID.Templates

  (** `FOLDERID_Videos` *)
  let video_dir = get_folderid GUID.Videos
end

module Project_dirs (App_id : App_id) = struct
  let mk folderid dir =
    Option.map
      (fun folderid_path ->
        Fpath.(folderid_path / App_id.organization / App_id.application / dir) )
      (get_folderid folderid)

  (** `FOLDERID_LocalApplicationData`/<project_path>/cache *)
  let cache_dir = mk GUID.LocalApplicationData "cache"

  (** `FOLDERID_ApplicationData`/<project_path>/config *)
  let config_dir = mk GUID.ApplicationData "config"

  (** `FOLDERID_ApplicationData`/<project_path>/data *)
  let data_dir = mk GUID.ApplicationData "data"

  (** `FOLDERID_LocalApplicationData`/<project_path>/data *)
  let data_local_dir = mk GUID.LocalApplicationData "data"

  (** `FOLDERID_ApplicationData`/<project_path>/config *)
  let preference_dir = mk GUID.ApplicationData "config"

  let state_dir = cache_dir

  (** None *)
  let runtime_dir = None
end
