(** Wrapper for {{!LuaStub.Types.State} [State]} *)

(** {{!LuaStub.Types.State.t} [State.t]} type is still abstract. *)
type u = LuaStub.Types.State.t

(** Almost {{!LuaStub.Types.State.t} [State.t]} is used with C pointer. *)
type t = u Ctypes.ptr
