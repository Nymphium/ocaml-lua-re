module Bwd = LuaStub.Types.Gc

type t =
  [ `Stop
  | `Restart
  | `Collect
  | `Count
  | `Countb
  | `Isrunning
  | `Setpause
  | `Setstepmul
  | `Setmajorinc
  | `Inc
  | `Gen
  ]
[@@deriving show, eq]

let fwd : Bwd.t -> t = function
  | t when t = Bwd.stop -> `Stop
  | t when t = Bwd.restart -> `Restart
  | t when t = Bwd.collect -> `Collect
  | t when t = Bwd.count -> `Count
  | t when t = Bwd.countb -> `Countb
  | t when t = Bwd.isrunning -> `Isrunning
  | t when t = Bwd.setpause -> `Setpause
  | t when t = Bwd.setstepmul -> `Setstepmul
  | t when t = Bwd.setmajorinc -> `Setmajorinc
  | t when t = Bwd.inc -> `Inc
  | t when t = Bwd.gen -> `Gen
  | t ->
    (* This should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua gc: %d\n" (Obj.magic t)
;;

let bwd : t -> Bwd.t = function
  | `Stop -> Bwd.stop
  | `Restart -> Bwd.restart
  | `Collect -> Bwd.collect
  | `Count -> Bwd.count
  | `Countb -> Bwd.countb
  | `Isrunning -> Bwd.isrunning
  | `Setpause -> Bwd.setpause
  | `Setstepmul -> Bwd.setstepmul
  | `Setmajorinc -> Bwd.setmajorinc
  | `Inc -> Bwd.inc
  | `Gen -> Bwd.gen
;;
