
module Apply (F : Cstubs.FOREIGN) = struct

  open Ctypes
  open F
  open Win_types
  
  module Kernel32 = struct
  
  (** see
      https://docs.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-widechartomultibyte *)

    let wide_char_to_multi_byte =
      foreign "WideCharToMultiByte" (
        UINT.t @->        (* UINT   CodePage *)
        DWORD.t @->       (* DWORD  dwFlags *)
        LPWCH.t @->       (* LPCWCH lpWideCharStr *)
        Int.t @->         (* int    cchWideChar *)
        LPSTR.t @->       (* LPSTR  lpMultiByteStr *)
        Int.t @->         (* int    cbMultiByte *)
        LPCH.t @->        (* LPCCH  lpDefaultChar *)
        LPBOOL.t @->      (* LPBOOL lpUsedDefaultChar *)
        returning Int.t   (* int *)
      )

  end
  
  module Shell32 = struct

  (** see
      https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath *)

    let sh_get_known_folder_path =
      foreign "SHGetKnownFolderPath" (
        ptr GUID.t @->          (* REFKNOWNFOLDERID rfid     (= GUID * ) *)
        Known_folder_flag.t @-> (* DWORD            dwFlags  (= unsigned long) *)
        Token.t @->             (* HANDLE           hToken   (= void * ) *)
        ptr PWSTR.t @->         (* PWSTR *          ppszPath (= short unsigned int ** ) *)
        returning Hresult.t     (* HRESULT *)
      )

  end

end
