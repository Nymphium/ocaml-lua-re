(** Wrapper for {{!LuaStub.Types.Ltype} [Ltype]} *)

module Bwd = LuaStub.Types.Ltype

type t =
  [ `Nil
  | `Boolean
  | `Lightuserdata
  | `Number
  | `String
  | `Bwdable
  | `Function
  | `Userdata
  | `Bwdhread
  ]
[@@deriving show, eq]

let of_bwd : Bwd.t -> t = function
  | t when t = Bwd.nil -> `Nil
  | t when t = Bwd.boolean -> `Boolean
  | t when t = Bwd.lightuserdata -> `Lightuserdata
  | t when t = Bwd.number -> `Number
  | t when t = Bwd.string -> `String
  | t when t = Bwd.table -> `Bwdable
  | t when t = Bwd.function_ -> `Function
  | t when t = Bwd.userdata -> `Userdata
  | t when t = Bwd.thread -> `Bwdhread
  | t ->
    (* Bwdhis should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua type: %d\n" (Obj.magic t)
;;

let to_bwd : t -> Bwd.t = function
  | `Nil -> Bwd.nil
  | `Boolean -> Bwd.boolean
  | `Lightuserdata -> Bwd.lightuserdata
  | `Number -> Bwd.number
  | `String -> Bwd.string
  | `Bwdable -> Bwd.table
  | `Function -> Bwd.function_
  | `Userdata -> Bwd.userdata
  | `Bwdhread -> Bwd.thread
;;
