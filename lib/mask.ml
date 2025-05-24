module Bwd = LuaStub.Types.Mask

type t =
  [ `Call
  | `Ret
  | `Line
  | `Count
  ]
[@@deriving show, eq]

let fwd : Bwd.t -> t = function
  | t when t = Bwd.call -> `Call
  | t when t = Bwd.ret -> `Ret
  | t when t = Bwd.line -> `Line
  | t when t = Bwd.count -> `Count
  | t ->
    (* This should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua mask: %d\n" (Obj.magic t)
;;

let bwd : t -> Bwd.t = function
  | `Call -> Bwd.call
  | `Ret -> Bwd.ret
  | `Line -> Bwd.line
  | `Count -> Bwd.count
;;
