module type Base_dirs = sig
  val home_dir : string option
  val cache_dir : string option
  val config_dir : string option
  val data_dir : string option
  val data_local_dir : string option
  val preference_dir : string option
  val runtime_dir : string option
  val executable_dir : string option
end

module type User_dirs = sig
  val home_dir : string option
  val audio_dir : string option
  val desktop_dir : string option
  val document_dir : string option
  val download_dir : string option
  val font_dir : string option
  val picture_dir : string option
  val public_dir : string option
  val template_dir : string option
  val video_dir : string option
end

module type App_id = sig
  val qualifier : string
  val organization : string
  val application : string
end

module type Project_dirs = sig
  val cache_dir : string option
  val config_dir : string option
  val data_dir : string option
  val data_local_dir : string option
  val preference_dir : string option
  val runtime_dir : string option
end

module Base_dirs () : Base_dirs
module User_dirs () : User_dirs
module Project_dirs (App_id : App_id) : Project_dirs
