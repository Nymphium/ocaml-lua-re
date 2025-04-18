(**  Wrapper for {{!LuaStub.Types.Ref} [Ref]} *)

module Bwd = LuaStub.Types.Ref

type t =
  [ `Nil
  | `Noref
  ]
[@@deriving show, eq]

let of_bwd : Bwd.t -> t = function
  | t when t = Bwd.nil -> `Nil
  | t when t = Bwd.noref -> `Noref
  | t ->
    (* This should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua ref: %d\n" (Obj.magic t)
;;

let to_bwd : t -> Bwd.t = function
  | `Nil -> Bwd.nil
  | `Noref -> Bwd.noref
;;
