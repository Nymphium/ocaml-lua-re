(* see https://dune.readthedocs.io/en/stable/quick-start.html#defining-a-library-with-c-stubs-using-pkg-config *)
module C = Configurator.V1

let () =
  C.main ~name:"discover" (fun c ->
    let default : C.Pkg_config.package_conf = { libs = [ "-llua" ]; cflags = [] } in
    let conf =
      match C.Pkg_config.get c with
      | None -> default
      | Some pc ->
        (match C.Pkg_config.query pc ~package:"lua" with
         | None -> default
         | Some deps -> deps)
    in
    C.Flags.write_sexp "c_flags.sexp" conf.cflags)
;;
