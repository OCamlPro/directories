let () =
  let module App_id = struct
    let qualifier = "com"
    let organization = "YourCompany"
    let application = "yourapp"
  end in
  let module M = Directories.Project_dirs (App_id) in
  let option_value = function None -> "None" | Some v -> v in
  Format.printf "cache dir  = `%s`@." (option_value M.cache_dir);
  Format.printf "config dir = `%s`@." (option_value M.config_dir);
  Format.printf "data dir   = `%s`@." (option_value M.data_dir)
