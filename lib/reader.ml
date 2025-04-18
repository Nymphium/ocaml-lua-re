open LuaStub
open Ctypes

open struct
  module T = Types
end

type t = State.t -> unit ptr -> Unsigned.size_t ptr -> string
type bwd = t static_funptr

let to_bwd : t -> bwd =
  coerce
    (Foreign.funptr @@ ptr T.State.t @-> ptr void @-> ptr size_t @-> returning @@ string)
    T.Reader.t
;;
