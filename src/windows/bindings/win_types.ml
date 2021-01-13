
open Ctypes

module CHAR = struct
  type t = char typ
  let t = char
end

module LPCH = struct
  type t = CHAR.t ptr typ
  let t = ptr CHAR.t
  let null = from_voidp CHAR.t Ctypes.null
end

module PCH = LPCH

module WCHAR = struct
  type t = int typ
  let t = uint16_t
end

module LPWCH = struct
  type t = WCHAR.t ptr typ
  let t = ptr WCHAR.t
  let null = from_voidp WCHAR.t Ctypes.null
end

module PWCH = LPWCH

module BOOL = struct
  type t = bool
  let of_int32 i = not (Int32.equal Int32.zero i)
  let to_int32 b = if b then Int32.one else Int32.zero
  let t = Ctypes.view ~read:of_int32 ~write:to_int32 Ctypes.int32_t
end

module LPBOOL = struct
  type t = BOOL.t ptr typ
  let t = ptr BOOL.t
  let null = from_voidp BOOL.t Ctypes.null
end

module PBOOL = LPBOOL

module Int = struct
  type t = int32 typ
  let t = int32_t
end

module UINT = struct
  type t = int32 typ
  let t = int32_t
end

module DWORD = struct
  type t = int32 typ
  let t = int32_t
end

module LPSTR = struct
  type t = CHAR.t ptr typ
  let t = ptr CHAR.t
  let null = from_voidp CHAR.t Ctypes.null
end

module PSTR = LPSTR

module LPWSTR = struct
  type t = WCHAR.t ptr typ
  let t = ptr WCHAR.t
  let null = from_voidp WCHAR.t Ctypes.null
end

module PWSTR = LPWSTR

(** see
    https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/ne-shlobj_core-known_folder_flag *)
module Known_folder_flag = struct
  type t =
    | Default
    | Force_app_data_redirection
    | Return_filter_redirection_target
    | Force_package_redirection
    | No_package_redirection
    | Create
    | Dont_verify
    | Dont_unexpand
    | No_alias
    | Init
    | Default_path
    | Not_parent_relative
    | Simple_idlist
    | Alias_only

  let to_int32 = function
    | Default -> 0x00000000l
    | Force_app_data_redirection -> 0x00080000l
    | Return_filter_redirection_target -> 0x00040000l
    | Force_package_redirection -> 0x00020000l (* replaces Force_appcontainer_redirection *)
    | No_package_redirection -> 0x00010000l (* replaces No_appcontainer_redirection *)
    | Create -> 0x00008000l
    | Dont_verify -> 0x00004000l
    | Dont_unexpand -> 0x00002000l
    | No_alias -> 0x00001000l
    | Init -> 0x00000800l
    | Default_path -> 0x00000400l
    | Not_parent_relative -> 0x00000200l
    | Simple_idlist -> 0x0000000100l
    | Alias_only -> 0x80000000l

  let of_int32 = function
    | 0x00000000l -> Default
    | 0x00080000l -> Force_app_data_redirection
    | 0x00040000l -> Return_filter_redirection_target
    | 0x00020000l -> Force_package_redirection (* Force_appcontainer_redirection *)
    | 0x00010000l -> No_package_redirection (* No_appcontainer_redirection *)
    | 0x00008000l -> Create
    | 0x00004000l -> Dont_verify
    | 0x00002000l -> Dont_unexpand
    | 0x00001000l -> No_alias
    | 0x00000800l -> Init
    | 0x00000400l -> Default_path
    | 0x00000200l -> Not_parent_relative
    | 0x00000100l -> Simple_idlist
    | 0x80000000l -> Alias_only
    | n ->
      raise
      @@ Invalid_argument (Format.sprintf "Known_folder_flag.of_int: %ld" n)

  let t = Ctypes.view ~read:of_int32 ~write:to_int32 Ctypes.int32_t
end

(** see https://docs.microsoft.com/en-us/windows/win32/secauthz/access-tokens *
    as we don't want into troubles, we just bind what we might need... *)
module Token = struct
  type t =
    | Default_user
    | Current_user

  let to_ptr t =
	let i =
	  match t with
	  | Default_user -> -1
	  | Current_user -> 0
	in
	Ctypes.ptr_of_raw_address (Nativeint.of_int i)

  let of_ptr p =
	match Nativeint.to_int (Ctypes.raw_address_of_ptr p) with
    | -1 -> Default_user
    | 0 -> Current_user
    | n -> raise @@ Invalid_argument (Format.sprintf "Token.of_int: %d" n)

  let t = Ctypes.view ~read:of_ptr ~write:to_ptr (Ctypes.ptr Ctypes.void)
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
    | S_ok ->           0x00000000l
    | E_abort ->        0x80004004l
    | E_accessdenied -> 0x80070005l
    | E_fail ->         0x80004005l
    | E_handle ->       0x80070006l
    | E_invalid_arg ->  0x80070057l
    | E_nointerface ->  0x80004002l
    | E_notimpl ->      0x80004001l
    | E_outofmemory ->  0x8007000El
    | E_pointer ->      0x80004003l
    | E_unexpected ->   0x8000FFFFl

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
    | UserProfile ->          (0x5E6C858F, 0x0E22, 0x4760, 0x7371B61733EAFE9AL)
    | LocalApplicationData -> (0xF1B32785, 0x6FBA, 0x4FCF, 0x9170157F8E7B559DL)
    | ApplicationData ->      (0x3EB685DB, 0x65F9, 0x4CF6, 0x3D9F7265EFE33AA0L)
    | Music ->                (0x4BD8D571, 0x6D19, 0x48D3, 0x430E0820224297BEL)
    | Desktop ->              (0xB4BFCC3A, 0xDB2C, 0x424C, 0x41C6879AE97F29B0L)
    | Documents ->            (0xFDD39AD0, 0x238F, 0x46AF, 0xC7690348856CB4ADL)
    | Downloads ->            (0x374DE290, 0x123F, 0x4565, 0x7B465E92C4396491L)
    | Pictures ->             (0x33E28130, 0x4E1E, 0x4676, 0xBBC33B5C39985A83L)
    | Public ->               (0xDFDF76A2, 0xC82A, 0x4D63, 0x857345AC44566A90L)
    | Templates ->            (0xA63293E8, 0x664E, 0x48DB, 0xF709059E75DF79A0L)
    | Videos ->               (0x18989B1D, 0x99B5, 0x455B, 0xFCDDE4747CAB1C84L)

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
