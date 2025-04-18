(** Wrapper for {{!LuaStub.Types.Code} [Code]} *)

module Bwd = LuaStub.Types.Code

(** Successful code *)
type ok = [ `Ok ] [@@deriving show, eq, ord]

(** The status for yielded coroutine. *)
type yield = [ `Yield ] [@@deriving show, eq, ord]

(** Error codes *)
type err =
  [ `ErrRun
  | `ErrMem
  | `ErrErr
  | `ErrSyntax
  | `ErrGCMM
  | `ErrFile
  ]
[@@deriving show, eq, ord]

(** [t] is the union of {{!ok} [ok]}, {{!yield} [yield]} and {{!err} [err]}. *)
type t =
  [ ok
  | yield
  | err
  ]
[@@deriving show, eq, ord]

(** Converts from {{!LuaStub.Types.Code} backward}. *)
let of_bwd : Bwd.t -> t = function
  | t when t = Bwd.ok -> `Ok
  | t when t = Bwd.yield -> `Yield
  | t when t = Bwd.errrun -> `ErrRun
  | t when t = Bwd.errmem -> `ErrMem
  | t when t = Bwd.errerr -> `ErrErr
  | t when t = Bwd.errgcmm -> `ErrGCMM
  | t when t = Bwd.errfile -> `ErrFile
  | t ->
    (* This should never happen *)
    failwith @@ Printf.sprintf "Unknown Lua error code: %d\n" (Obj.magic t)
;;

(* Converts to {{!LuaStub.Types.Code} backward}. *)
let to_bwd : t -> Bwd.t = function
  | `Ok -> Bwd.ok
  | `Yield -> Bwd.yield
  | `ErrRun -> Bwd.errrun
  | `ErrSyntax -> Bwd.errsyntax
  | `ErrMem -> Bwd.errmem
  | `ErrErr -> Bwd.errerr
  | `ErrGCMM -> Bwd.errgcmm
  | `ErrFile -> Bwd.errfile
;;

(** Converts the status into [Result] type. *)
let as_result : t -> ([ ok | yield ], err) result = function
  | `Ok -> Ok `Ok
  | `Yield -> Ok `Yield
  | `ErrRun -> Error `ErrRun
  | `ErrSyntax -> Error `ErrSyntax
  | `ErrMem -> Error `ErrMem
  | `ErrErr -> Error `ErrErr
  | `ErrGCMM -> Error `ErrGCMM
  | `ErrFile -> Error `ErrFile
;;
