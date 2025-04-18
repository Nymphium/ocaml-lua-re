open LuaStub
open Ctypes

open struct
  module T = Types
end

type t = State.t -> unit ptr -> Unsigned.size_t -> unit ptr -> Code.t
type bwd = (State.t -> unit ptr -> Unsigned.size_t -> unit ptr -> T.Code.t) static_funptr

let to_bwd (f : t) =
  coerce
    (Foreign.funptr
     @@ ptr T.State.t
     @-> ptr void
     @-> size_t
     @-> ptr void
     @-> returning
     @@ T.Code.t)
    T.Writer.t
    (fun state p sz ud -> f state p sz ud |> Code.to_bwd)
;;
