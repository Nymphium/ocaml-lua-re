open LuaStub
open Ctypes

open struct
  module T = Types
end

type t = State.t -> int
type bwd = t static_funptr

let to_bwd : t -> bwd =
  coerce (Foreign.funptr @@ ptr T.State.t @-> returning int) T.CFunction.t
;;
