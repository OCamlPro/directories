open Ctypes
open Foreign
open Common

[@@@ocaml.warning "-37"]

module Known_folder_flag = struct
  (** see
      https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/ne-shlobj_core-known_folder_flag *)
  type t =
    | Default
    | Force_app_data_redirection
    | Return_filter_redirection_target
    | Force_package_redirection
    | No_package_redirection
    | Force_appcontainer_redirection
    | No_appcontainer_redirection
    | Create
    | Dont_verify
    | Dont_unexpand
    | No_alias
    | Init
    | Default_path
    | Not_parent_relative
    | Simple_idlist
    | Alias_only

  let to_int = function
    | Default -> 0
    | Force_app_data_redirection -> 1
    | Return_filter_redirection_target -> 2
    | Force_package_redirection -> 3
    | No_package_redirection -> 4
    | Force_appcontainer_redirection -> 5
    | No_appcontainer_redirection -> 6
    | Create -> 7
    | Dont_verify -> 8
    | Dont_unexpand -> 9
    | No_alias -> 10
    | Init -> 11
    | Default_path -> 12
    | Not_parent_relative -> 13
    | Simple_idlist -> 14
    | Alias_only -> 15

  let of_int = function
    | 0 -> Default
    | 1 -> Force_app_data_redirection
    | 2 -> Return_filter_redirection_target
    | 3 -> Force_package_redirection
    | 4 -> No_package_redirection
    | 5 -> Force_appcontainer_redirection
    | 6 -> No_appcontainer_redirection
    | 7 -> Create
    | 8 -> Dont_verify
    | 9 -> Dont_unexpand
    | 10 -> No_alias
    | 11 -> Init
    | 12 -> Default_path
    | 13 -> Not_parent_relative
    | 14 -> Simple_idlist
    | 15 -> Alias_only
    | n ->
      raise
      @@ Invalid_argument (Format.sprintf "Known_folder_flag.of_int: %d" n)

  let t = Ctypes.view ~read:of_int ~write:to_int Ctypes.int
end

(** see https://docs.microsoft.com/en-us/windows/win32/secauthz/access-tokens *
    as we don't want into troubles, we just bind what we might need... *)
module Token = struct
  type t =
    | Default_user
    | Current_user

  let to_int = function
    | Default_user -> -1
    | Current_user -> 0

  let of_int = function
    | -1 -> Default_user
    | 0 -> Current_user
    | n -> raise @@ Invalid_argument (Format.sprintf "Token.of_int: %d" n)

  let t = Ctypes.view ~read:of_int ~write:to_int Ctypes.int
end

(** see
    https://docs.microsoft.com/en-us/windows/win32/seccrypto/common-hresult-values *)
module Hresult = struct
  type t =
    | S_ok
    | E_abort
    | E_accessdenied
    | E_fail
    | E_handle
    | E_invalid_arg
    | E_nointerface
    | E_notimpl
    | E_outofmemory
    | E_pointer
    | E_unexpected

  let to_int32 = function
    | S_ok -> Int32.of_string "0x00000000"
    | E_abort -> Int32.of_string "0x80004004"
    | E_accessdenied -> Int32.of_string "0x80070005"
    | E_fail -> Int32.of_string "0x80004005"
    | E_handle -> Int32.of_string "0x80070006"
    | E_invalid_arg -> Int32.of_string "0x80070057"
    | E_nointerface -> Int32.of_string "0x80004002"
    | E_notimpl -> Int32.of_string "0x80004001"
    | E_outofmemory -> Int32.of_string "0x8007000E"
    | E_pointer -> Int32.of_string "0x80004003"
    | E_unexpected -> Int32.of_string "0x8000FFFF"

  let of_int32 (n : Int32.t) =
    match n with
    | 0x00000000l -> S_ok
    | 0x80004004l -> E_abort
    | 0x80070005l -> E_accessdenied
    | 0x80004005l -> E_fail
    | 0x80070006l -> E_handle
    | 0x80070057l -> E_invalid_arg
    | 0x80004002l -> E_nointerface
    | 0x80004001l -> E_notimpl
    | 0x8007000El -> E_outofmemory
    | 0x80004003l -> E_pointer
    | 0x8000FFFFl -> E_unexpected
    | n ->
      raise
      @@ Invalid_argument (Format.sprintf "Hresult.of_int: %x" (Int32.to_int n))

  let t = Ctypes.view ~read:of_int32 ~write:to_int32 Ctypes.int32_t
end

module GUID = struct
  type t =
    | UserProfile
    | LocalApplicationData
    | ApplicationData
    | Music
    | Desktop
    | Documents
    | Downloads
    | Pictures
    | Public
    | Templates
    | Videos

  (*
  let to_guid = function
    | UserProfile          -> 0x5E6C858F, 0x0E22, 0x4760, 0x9A, 0xFE, 0xEA, 0x33, 0x17, 0xB6, 0x71, 0x73
    | LocalApplicationData -> 0xF1B32785, 0x6FBA, 0x4FCF, 0x9D, 0x55, 0x7B, 0x8E, 0x7F, 0x15, 0x70, 0x91
    | ApplicationData      -> 0x3EB685DB, 0x65F9, 0x4CF6, 0xA0, 0x3A, 0xE3, 0xEF, 0x65, 0x72, 0x9F, 0x3D
    | Music                -> 0x4BD8D571, 0x6D19, 0x48D3, 0xBE, 0x97, 0x42, 0x22, 0x20, 0x08, 0x0E, 0x43
    | Desktop              -> 0xB4BFCC3A, 0xDB2C, 0x424C, 0xB0, 0x29, 0x7F, 0xE9, 0x9A, 0x87, 0xC6, 0x41
    | Documents            -> 0xFDD39AD0, 0x238F, 0x46AF, 0xAD, 0xB4, 0x6C, 0x85, 0x48, 0x03, 0x69, 0xC7
    | Downloads            -> 0x374DE290, 0x123F, 0x4565, 0x91, 0x64, 0x39, 0xC4, 0x92, 0x5E, 0x46, 0x7B
    | Pictures             -> 0x33E28130, 0x4E1E, 0x4676, 0x83, 0x5A, 0x98, 0x39, 0x5C, 0x3B, 0xC3, 0xBB
    | Public               -> 0xDFDF76A2, 0xC82A, 0x4D63, 0x90, 0x6A, 0x56, 0x44, 0xAC, 0x45, 0x73, 0x85
    | Templates            -> 0xA63293E8, 0x664E, 0x48DB, 0xA0, 0x79, 0xDF, 0x75, 0x9E, 0x05, 0x09, 0xF7
    | Videos               -> 0x18989B1D, 0x99B5, 0x455B, 0x84, 0x1C, 0xAB, 0x7C, 0x74, 0xE4, 0xDD, 0xFC
  *)

  let to_guid = function
    | UserProfile ->
      (0x5E6C858F, 0x0E22, 0x4760, Int64.of_string "0x7371B61733EAFE9A")
    | LocalApplicationData ->
      (0xF1B32785, 0x6FBA, 0x4FCF, Int64.of_string "0x9170157F8E7B559D")
    | ApplicationData ->
      (0x3EB685DB, 0x65F9, 0x4CF6, Int64.of_string "0x3D9F7265EFE33AA0")
    | Music -> (0x4BD8D571, 0x6D19, 0x48D3, Int64.of_string "0x430E0820224297BE")
    | Desktop ->
      (0xB4BFCC3A, 0xDB2C, 0x424C, Int64.of_string "0x41C6879AE97F29B0")
    | Documents ->
      (0xFDD39AD0, 0x238F, 0x46AF, Int64.of_string "0xC7690348856CB4AD")
    | Downloads ->
      (0x374DE290, 0x123F, 0x4565, Int64.of_string "0x7B465E92C4396491")
    | Pictures ->
      (0x33E28130, 0x4E1E, 0x4676, Int64.of_string "0xBBC33B5C39985A83")
    | Public ->
      (0xDFDF76A2, 0xC82A, 0x4D63, Int64.of_string "0x857345AC44566A90")
    | Templates ->
      (0xA63293E8, 0x664E, 0x48DB, Int64.of_string "0xF709059E75DF79A0")
    | Videos ->
      (0x18989B1D, 0x99B5, 0x455B, Int64.of_string "0xFCDDE4747CAB1C84")

  let t : t structure typ = structure "_GUID"

  let data1 = field t "Data1" ulong

  let data2 = field t "Data2" ushort

  let data3 = field t "Data3" ushort

  (* let data4 = field t "Data4 (array 8 uchar)"*)
  let data4 = field t "Data4" int64_t

  let () = seal t

  let to_guid guid =
    (* let d1, d2, d3, d4_0, d4_1, d4_2, d4_3, d4_4, d4_5, d4_6, d4_7 = to_guid guid in *)
    let d1, d2, d3, d4 = to_guid guid in
    let guid = make t in
    setf guid data1 (Unsigned.ULong.of_int d1);
    setf guid data2 (Unsigned.UShort.of_int d2);
    setf guid data3 (Unsigned.UShort.of_int d3);
    setf guid data4 d4;
    (* let l = [d4_0; d4_1; d4_2; d4_3; d4_4; d4_5; d4_6; d4_7] in
       setf guid data4 (CArray.map uchar Unsigned.UChar.of_int (CArray.of_list int l)); *)
    guid
end

(** see
    https://docs.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-widechartomultibyte *)
let wide_char_to_multi_byte =
  foreign "WideCharToMultiByte"
    ( int32_t @-> int32_t @-> ptr void @-> int32_t @-> ptr void @-> int32_t
    @-> ptr void @-> ptr void @-> returning int32_t )

let wstring_to_string wstr =
  let path_len =
    wide_char_to_multi_byte 65001l 0l wstr (-1l) null 0l null null
  in
  let path = to_voidp (allocate_n char ~count:(Int32.to_int path_len)) in
  let _ =
    wide_char_to_multi_byte 65001l 0l wstr (-1l) path path_len null null
  in
  coerce (ptr void) string path

(** see
    https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath *)
let shell32 = Dl.dlopen ~flags:[ Dl.RTLD_LAZY ] ~filename:"SHELL32"

let sh_get_known_folder_path =
  foreign ~from:shell32 "SHGetKnownFolderPath"
    ( GUID.t @-> Known_folder_flag.t @-> Token.t
    @-> ptr (ptr void)
    @-> returning Hresult.t )

let get_folderid id =
  let wpath_ptr = allocate (ptr void) null in
  let result =
    sh_get_known_folder_path (GUID.to_guid id) Known_folder_flag.Default
      Token.Current_user wpath_ptr
  in
  match result with
  | S_ok -> Some (wstring_to_string !@wpath_ptr)
  | _err -> None

module Base_dirs () = struct
  (** {FOLDERID_UserProfile} *)
  let home_dir : string option = get_folderid GUID.UserProfile

  (** {FOLDERID_LocalApplicationData} *)
  let cache_dir = get_folderid GUID.LocalApplicationData

  (** {FOLDERID_ApplicationData} *)
  let config_dir = get_folderid GUID.ApplicationData

  (** {FOLDERID_ApplicationData} *)
  let data_dir = get_folderid GUID.ApplicationData

  (** {FOLDERID_LocalApplicationData} *)
  let data_local_dir = get_folderid GUID.LocalApplicationData

  (** {FOLDERID_ApplicationData} *)
  let preference_dir = get_folderid GUID.ApplicationData

  (** None *)
  let runtime_dir = None

  (** None *)
  let executable_dir = None
end

module User_dirs () = struct
  module Base_dirs = Base_dirs ()

  (** {FOLDERID_UserProfile} *)
  let home_dir = Base_dirs.home_dir

  (** {FOLDERID_Music} *)
  let audio_dir = get_folderid GUID.Music

  (** {FOLDERID_Desktop} *)
  let desktop_dir = get_folderid GUID.Music

  (** {FOLDERID_Documents} *)
  let document_dir = get_folderid GUID.Documents

  (** {FOLDERID_Downloads} *)
  let download_dir = get_folderid GUID.Downloads

  (** None *)
  let font_dir = None

  (** {FOLDERID_Pictures} *)
  let picture_dir = get_folderid GUID.Pictures

  (** {FOLDERID_Public} *)
  let public_dir = get_folderid GUID.Public

  (** {FOLDERID_Templates} *)
  let template_dir = get_folderid GUID.Templates

  (** {FOLDERID_Videos} *)
  let video_dir = get_folderid GUID.Videos
end

module Project_dirs (App_id : App_id) = struct
  (* TODO: check that the string is valid and format it correctly *)
  let project_path = App_id.application

  let mk folderid dir =
    option_map
      (fun folderid_path -> folderid_path / project_path / dir)
      (get_folderid folderid)

  (** {FOLDERID_LocalApplicationData}/<project_path>/cache *)
  let cache_dir = mk GUID.LocalApplicationData "cache"

  (** {FOLDERID_ApplicationData}/<project_path>/config *)
  let config_dir = mk GUID.ApplicationData "config"

  (** {FOLDERID_ApplicationData}/<project_path>/data *)
  let data_dir = mk GUID.ApplicationData "data"

  (** {FOLDERID_LocalApplicationData}/<project_path>/data *)
  let data_local_dir = mk GUID.LocalApplicationData "data"

  (** {FOLDERID_ApplicationData}/<project_path>/config *)
  let preference_dir = mk GUID.ApplicationData "config"

  (** None *)
  let runtime_dir = None
end
