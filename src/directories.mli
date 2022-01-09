module Base_dirs () : sig
  val home_dir : string option
  val cache_dir : string option
  val config_dir : string option
  val data_dir : string option
  val data_local_dir : string option
  val preference_dir : string option
  val runtime_dir : string option
  val state_dir : string option
  val executable_dir : string option
end

module User_dirs () : sig
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

module Project_dirs (App_id : sig
  val qualifier : string
  val organization : string
  val application : string
end) : sig
  val cache_dir : string option
  val config_dir : string option
  val data_dir : string option
  val data_local_dir : string option
  val preference_dir : string option
  val runtime_dir : string option
  val state_dir : string option
end
