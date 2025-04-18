(** {1 Coerce functions} *)

open LuaStub
open Ctypes

open struct
  module T = Types
end

let hook = coerce (Foreign.funptr @@ ptr T.State.t @-> returning int) T.Hook.t

let bwd_cfunction f =
  coerce T.CFunction.t (Foreign.funptr @@ ptr T.State.t @-> returning int) f
;;
