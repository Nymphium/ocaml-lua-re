open struct
  module T = LuaStub.Types
end

module Bwd = T.Hook

type t =
  [ `Call
  | `Ret
  | `Line
  | `Count
  | `Tailcall
  ]
[@@deriving show, eq]

let of_fwd : Bwd._t -> t = function
  | t when t = Bwd.call -> `Call
  | t when t = Bwd.ret -> `Ret
  | t when t = Bwd.line -> `Line
  | t when t = Bwd.count -> `Count
  | t when t = Bwd.tailcall -> `Tailcall
  | t ->
    (* This should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua hook: %d\n" (Obj.magic t)
;;

let to_bwd : t -> Bwd._t = function
  | `Call -> Bwd.call
  | `Ret -> Bwd.ret
  | `Line -> Bwd.line
  | `Count -> Bwd.count
  | `Tailcall -> Bwd.tailcall
;;

module F = struct
  open Ctypes

  type t = State.t -> Debug.t -> unit
  type bwd = t static_funptr

  let to_bwd : t -> bwd =
    coerce (Foreign.funptr @@ ptr T.State.t @-> ptr T.Debug.t @-> returning void) T.Hook.t
  ;;
end
