module Base_dirs () : sig
  val home_dir : Fpath.t option

  val cache_dir : Fpath.t option

  val config_dir : Fpath.t option

  val data_dir : Fpath.t option

  val data_local_dir : Fpath.t option

  val preference_dir : Fpath.t option

  val runtime_dir : Fpath.t option

  val state_dir : Fpath.t option

  val executable_dir : Fpath.t option
end

module User_dirs () : sig
  val home_dir : Fpath.t option

  val audio_dir : Fpath.t option

  val desktop_dir : Fpath.t option

  val document_dir : Fpath.t option

  val download_dir : Fpath.t option

  val font_dir : Fpath.t option

  val picture_dir : Fpath.t option

  val public_dir : Fpath.t option

  val template_dir : Fpath.t option

  val video_dir : Fpath.t option
end

module Project_dirs (App_id : sig
  val qualifier : string

  val organization : string

  val application : string
end) : sig
  val cache_dir : Fpath.t option

  val config_dir : Fpath.t option

  val data_dir : Fpath.t option

  val data_local_dir : Fpath.t option

  val preference_dir : Fpath.t option

  val runtime_dir : Fpath.t option

  val state_dir : Fpath.t option
end
