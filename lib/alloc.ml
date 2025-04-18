open LuaStub
open Ctypes

open struct
  module T = Types
end

type t = unit ptr -> unit ptr -> Unsigned.size_t -> Unsigned.size_t -> unit ptr
type bwd = t static_funptr

let to_bwd : t -> bwd =
  coerce
    (Foreign.funptr
     @@ ptr void
     @-> ptr void
     @-> size_t
     @-> size_t
     @-> returning
     @@ ptr void)
    T.Alloc.t
;;
