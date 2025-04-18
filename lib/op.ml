module Bwd = LuaStub.Types.Op

type t =
  [ `OpAdd
  | `OpSub
  | `OpMul
  | `OpDiv
  | `OpMod
  | `OpPow
  ]
[@@deriving show, eq]

let fwd : Bwd.t -> t = function
  | t when t = Bwd.add -> `OpAdd
  | t when t = Bwd.sub -> `OpSub
  | t when t = Bwd.mul -> `OpMul
  | t when t = Bwd.div -> `OpDiv
  | t when t = Bwd.mod_ -> `OpMod
  | t when t = Bwd.pow -> `OpPow
  | t ->
    (* This should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua op: %d\n" (Obj.magic t)
;;

module Comp = struct
  module Bwd = LuaStub.Types.Op.Comp

  type t =
    [ `OpEq
    | `OpLt
    | `OpLe
    ]
  [@@deriving show, eq]

  let fwd : Bwd.t -> t = function
    | t when t = Bwd.eq -> `OpEq
    | t when t = Bwd.lt -> `OpLt
    | t when t = Bwd.le -> `OpLe
    | t ->
      (* This should never happen *)
      failwith @@ Printf.sprintf "Unknown Lua op: %d\n" (Obj.magic t)
  ;;

  let bwd : t -> Bwd.t = function
    | `OpEq -> Bwd.eq
    | `OpLt -> Bwd.lt
    | `OpLe -> Bwd.le
  ;;
end
