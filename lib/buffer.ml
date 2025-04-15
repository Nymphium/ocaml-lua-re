open struct
  open LuaStub
  module F = Functions
  module T = Types
  module C = Ctypes
end

(** Creates a {{!LuaStub.Types.Buffer.type-t} [lua_Buffer]}. *)
let create ?size state =
  let b = Util.s_ptr T.Buffer.t in
  let () =
    match size with
    | Some size -> F.buffinitsize state b size
    | None -> F.buffinit state b
  in
  b
;;

(** Finalises a buffer [b] and returns the value as an OCaml string *)
let tostring state b =
  F.pushresult b;
  F.tostring state (-1)
;;
