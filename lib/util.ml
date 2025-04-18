open struct
  open LuaStub
  module F = Functions
  module T = Types
  module C = Ctypes
end

let popstring = Fun.flip F.checkstring (-1)
let popnumber = Fun.flip F.checknumber (-1)

(** Creates a new pointer of [typ]. *)
let s_ptr typ = C.allocate typ @@ C.make typ

(** Wraps C API functions those which returns {{!LuaStub.Types.Code} {e code}} with {{!Lua.Code} [Code]}. *)
let capi_call_code_as_result state f =
  f state
  |> Code.(Fun.compose as_result of_bwd)
  |> function
  | Ok _ -> Ok ()
  | Error e ->
    Error (`Msg (Printf.sprintf "Lua error %s: %s" (Code.show_err e) (popstring state)))
;;
