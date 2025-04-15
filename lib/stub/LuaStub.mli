(** This module provides bindings to the Lua 5.2 C API, allowing you to interact with Lua from OCaml.

    For more details about the API itself, {{:https://www.lua.org/manual/5.2/manual.html} See Lua 5.2 Manual}. *)

open Ctypes

(** [Types] is for types and constants. *)
module Types : sig
  (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_VERSION_NUM} [LUA_VERSION_NUM]} *)
  val version_num : int

  (**/**)

  type nonrec 'a typ = 'a typ
  type nonrec 'a ptr = 'a ptr
  type nonrec 'a structure = 'a structure
  type nonrec 'a static_funptr = 'a static_funptr

  val number : float typ
  val int : int typ
  val unsigned : Unsigned.UInt.t typ
  val integer : Ptrdiff.t typ
  val lu_byte : Unsigned.UChar.t typ
  val string : string typ
  val void : unit typ
  val ptr : 'a typ -> 'a ptr typ
  val size_t : Unsigned.size_t typ
  val char : char typ

  (**/**)

  (** [bool] is a wrapper for 0/1 value. *)
  val bool : bool typ

  (** [Code.t] represents {{:https://www.lua.org/source/5.2/lua.h.html#LUA_OK} [LUA_OK]} and other error codes. *)
  module Code : sig
    type t

    val t : t typ

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OK> *)
    val ok : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_YIELD> *)
    val yield : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_ERRRUN> *)
    val errrun : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_ERRSYNTAX> *)
    val errsyntax : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_ERRMEM> *)
    val errmem : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_ERRERR> *)
    val errerr : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_ERRGCMM> *)
    val errgcmm : t

    (** @see <https://www.lua.org/source/5.2/lauxlib.h.html#LUA_ERRFILE> *)
    val errfile : t
  end

  (* * [Ref.t] represents {{:https://www.lua.org/source/5.2/lua.h.html#LUA_REFNIL} [LUA_REFNIL]} and)
     {{:https://www.lua.org/source/5.2/lua.h.html#LUA_NOREF} [LUA_NOREF]}. *)
  module Ref : sig
    type t

    val t : t typ

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_REFNIL> *)
    val nil : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_NOREF> *)
    val noref : t
  end

  (** [State.t] represents {{:https://www.lua.org/manual/5.2/manual.html#lua_State} [lua_State]}. *)
  module State : sig
    type t

    val t : t typ
  end

  (** [Buffer.t] represents {{:https://www.lua.org/source/5.2/lauxlib.h.html#luaL_Buffer} [luaL_Buffer]}. *)
  module Buffer : sig
    type t

    val t : t typ
  end

  (** [Alloc.t] is a wrapper for {{:https://www.lua.org/manual/5.2/manual.html#lua_Alloc} [lua_Alloc]}. *)
  module Alloc : sig
    type t =
      (unit ptr -> unit ptr -> Unsigned.size_t -> Unsigned.Size_t.t -> unit ptr)
        static_funptr

    val t : t typ
  end

  (** [CFunction.t] is a wrapper for {{:https://www.lua.org/manual/5.2/manual.html#lua_CFunction} [lua_CFunction]}. *)
  module CFunction : sig
    type t = (State.t ptr -> int) static_funptr

    val t : t typ
  end

  (** [Reader.t] is a wrapper for {{:https://www.lua.org/manual/5.2/manual.html#lua_Reader} [lua_Reader]}. *)
  module Reader : sig
    type t = (State.t ptr -> unit ptr -> Unsigned.size_t ptr -> string) static_funptr

    val t : t typ
  end

  (** [Writer.t] is a wrapper for {{:https://www.lua.org/manual/5.2/manual.html#lua_Writer} [lua_Writer]}. *)
  module Writer : sig
    type t =
      (State.t ptr -> unit ptr -> Unsigned.size_t -> unit ptr -> Code.t) static_funptr

    val t : t typ
  end

  (** [Reg.t] is a wrapper for {{:https://www.lua.org/manual/5.2/manual.html#luaL_Reg} [luaL_Reg]}. *)
  module Reg : sig
    type t = [ `luaL_Reg ] structure

    val t : t typ
    val name : (string, t) field
    val func : ((State.t ptr -> int) static_funptr, t) field
  end

  (** [Debug.t] is a wrapper for {{:https://www.lua.org/manual/5.2/manual.html#lua_Debug} [lua_Debug]}. *)
  module Debug : sig
    type t = [ `lua_Debug ] structure

    val t : t typ
    val event : (int, t) field
    val name : (string, t) field
    val namewhat : (string, t) field
    val what : (string, t) field
    val source : (string, t) field
    val currentline : (int, t) field
    val linedefined : (int, t) field
    val lastlinedefined : (int, t) field
    val nups : (Unsigned.uchar, t) field
    val nparams : (Unsigned.uchar, t) field
    val isvararg : (bool, t) field
    val istailcall : (bool, t) field
    val short_src : (string, t) field
  end

  (** [LUA_OP*] *)
  module Op : sig
    type t

    val t : t typ

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPADD> *)
    val add : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPSUB> *)
    val sub : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPMUL> *)
    val mul : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPMOD> *)
    val div : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPMOD> *)
    val mod_ : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPPOW> *)
    val pow : t

    module Comp : sig
      type t

      (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPUNM> *)
      val eq : t

      (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPUNM> *)
      val lt : t

      (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_OPUNM> *)
      val le : t
    end
  end

  (** GC Options *)
  module Gc : sig
    type t

    val t : t typ

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCSTOP> *)
    val stop : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCRESTART> *)
    val restart : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCCOLLECT> *)
    val collect : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCCOUNT> *)
    val count : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCCOUNTB> *)
    val countb : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCSTEP> *)
    val step : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCSETPAUSE> *)
    val setpause : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCSETSTEPMUL> *)
    val setstepmul : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCSETPAUSE> *)
    val setmajorinc : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCSETMAJORINC> *)
    val isrunning : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCISRUNNING> *)
    val inc : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_GCINC> *)
    val gen : t
  end

  (** Event operations and {{:https://www.lua.org/manual/5.2/manual.html#lua_Hook} [lua_Hook]}.
      Also see {!LuaStub.Types.Mask} *)
  module Hook : sig
    type _t

    val _t : _t typ

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_HOOKCALL> *)

    val call : _t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_HOOKRET> *)
    val ret : _t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_HOOKLINE> *)
    val line : _t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_HOOKCOUNT> *)
    val count : _t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_HOOKTAILCALL> *)
    val tailcall : _t

    type t = (unit ptr ptr -> Debug.t ptr -> unit) static_funptr

    val t : t typ
  end

  (** Event masks *)
  module Mask : sig
    type t

    val t : t typ

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_MASKCALL> *)
    val call : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_MASKRET> *)
    val ret : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_MASKLINE> *)
    val line : t

    (** @see <https://www.lua.org/source/5.2/lua.h.html#LUA_MASKCOUNT> *)
    val count : t
  end

  (** Lua value-types, [LUA_T*] *)
  module Ltype : sig
    type t

    val t : t typ

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TNONE} [LUA_TNONE]} *)
    val none : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TNIL} [LUA_TNIL]} *)
    val nil : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TBOOLEAN} [LUA_TBOOLEAN]} *)
    val boolean : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TLIGHTUSERDATA} [LUA_TLIGHTUSERDATA]} *)
    val lightuserdata : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TNUMBER} [LUA_TNUMBER]} *)
    val number : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TSTRING} [LUA_TSTRING]} *)
    val string : t

    (** *{{:https://www.lua.org/source/5.2/lua.h.html#LUA_TTABLE} [LUA_TTABLE]} *)
    val table : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TFUNCTION} [LUA_TFUNCTION]} *)
    val function_ : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TUSERDATA} [LUA_TUSERDATA]} *)
    val userdata : t

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_TTHREAD} [LUA_TTHREAD]} *)
    val thread : t
  end
end

(** [Functions] is for Lua API functions and a few constants each of them are non-simple values. *)
module Functions : sig
  open Types

  (** {1 [Const]} *)

  (** For the limitation of ctypes, some of the constants are not defined in the direct way.
      The contstants those which are not int-like are defined in the module [Const] and have type [unit -> 'a].

      {@ocaml[
        # let open LuaStub.Functions.Const in
          (version_major ()) ^ "." ^ (version_minor ());;
        - : string = "5.2"
      ]} *)
  module Const : sig
    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_VERSION} [LUA_VERSION]} *)
    val version : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_VERSION_MAJOR} [LUA_VERSION_MAJOR]} *)
    val version_major : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_VERSION_MINOR} [LUA_VERSION_MINOR]} *)
    val version_minor : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_VERSION_RELEASE} [LUA_VERSION_RELEASE]} *)
    val version_release : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_RELEASE} [LUA_RELEASE]} *)
    val release : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_COPYRIGHT} [LUA_COPYRIGHT]} *)
    val copyright : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_AUTHORS} [LUA_AUTHORS]} *)
    val authors : unit -> string

    (** {{:https://www.lua.org/source/5.2/lua.h.html#LUA_SIGNATURE} [LUA_SIGNATURE]} *)
    val signature : unit -> string
  end

  (** {1 Functions} *)

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_absindex} [lua_absindex]} *)
  val absindex : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_arith} [lua_arith]} *)
  val arith : State.t ptr -> Op.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_atpanic} [lua_atpanic]} *)
  val atpanic : State.t ptr -> CFunction.t -> CFunction.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_call} [lua_call]} *)
  val call : State.t ptr -> int -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_callk} [lua_callk]} *)
  val callk : State.t ptr -> int -> int -> int -> CFunction.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_checkstack} [lua_checkstack]} *)
  val checkstack : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_close} [lua_close]} *)
  val close : State.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_compare} [lua_compare]} *)
  val compare : State.t ptr -> int -> int -> Op.Comp.t -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_concat} [lua_concat]} *)
  val concat : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_copy} [lua_copy]} *)
  val copy : State.t ptr -> int -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_createtable} [lua_createtable]} *)
  val createtable : State.t ptr -> int -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_dump} [lua_dump]} *)
  val dump : State.t ptr -> CFunction.t -> unit ptr -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_error} [lua_error]} *)
  val error : State.t ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_gc} [lua_gc]} *)
  val gc : State.t ptr -> int -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getallocf} [lua_getallocf]} *)
  val getallocf : State.t ptr -> unit ptr ptr -> Alloc.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getctx} [lua_getctx]} *)
  val getctx : State.t ptr -> int ptr -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getfield} [lua_getfield]} *)
  val getfield : State.t ptr -> int -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getglobal} [lua_getglobal]} *)
  val getglobal : State.t ptr -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getmetatable} [lua_getmetatable]} *)
  val getmetatable : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_gettable} [lua_gettable]} *)
  val gettable : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_gettop} [lua_gettop]} *)
  val gettop : State.t ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getuservalue} [lua_getuservalue]} *)
  val getuservalue : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_insert} [lua_insert]} *)
  val insert : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isboolean} [lua_isboolean]} *)
  val isboolean : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_iscfunction} [lua_iscfunction]} *)
  val iscfunction : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_islightuserdata} [lua_islightuserdata]} *)
  val islightuserdata : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isnil} [lua_isnil]} *)
  val isnil : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isnone} [lua_isnone]} *)
  val isnone : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isnoneornil} [lua_isnoneornil]} *)
  val isnoneornil : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isnumber} [lua_isnumber]} *)
  val isnumber : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isstring} [lua_isstring]} *)
  val isstring : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_istable} [lua_istable]} *)
  val istable : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isthread} [lua_isthread]} *)
  val isthread : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_isuserdata} [lua_isuserdata]} *)
  val isuserdata : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_len} [lua_len]} *)
  val len : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_load} [lua_load]} *)
  val load : State.t ptr -> Reader.t -> unit ptr -> string -> string -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_newstate} [lua_newstate]} *)
  val newstate : Alloc.t -> unit ptr -> State.t ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_newtable} [lua_newtable]} *)
  val newtable : State.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_newthread} [lua_newthread]} *)
  val newthread : State.t ptr -> State.t ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_newuserdata} [lua_newuserdata]} *)
  val newuserdata : State.t ptr -> Unsigned.size_t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_next} [lua_next]} *)
  val next : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pcall} [lua_pcall]} *)
  val pcall : State.t ptr -> int -> int -> int -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pcallk} [lua_pcallk]} *)
  val pcallk : State.t ptr -> int -> int -> int -> int -> CFunction.t -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pop} [lua_pop]} *)
  val pop : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushboolean} [lua_pushboolean]} *)
  val pushboolean : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushcclosure} [lua_pushcclosure]} *)
  val pushcclosure : State.t ptr -> CFunction.t -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushcfunction} [lua_pushcfunction]} *)
  val pushcfunction : State.t ptr -> CFunction.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushfstring} [lua_pushfstring]} *)
  val pushfstring : State.t ptr -> string -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushglobaltable} [lua_pushglobaltable]} *)
  val pushglobaltable : State.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushinteger} [lua_pushinteger]} *)
  val pushinteger : State.t ptr -> Ptrdiff.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushlightuserdata} [lua_pushlightuserdata]} *)
  val pushlightuserdata : State.t ptr -> unit ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushlstring} [lua_pushlstring]} *)
  val pushlstring : State.t ptr -> string -> Unsigned.size_t -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushnil} [lua_pushnil]} *)
  val pushniil : State.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushnumber} [lua_pushnumber]} *)
  val pushnumber : State.t ptr -> float -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushstring} [lua_pushstring]} *)
  val pushstring : State.t ptr -> string -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushthread} [lua_pushthread]} *)
  val pushthread : State.t ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushunsigned} [lua_pushunsigned]} *)
  val pushunsigned : State.t ptr -> Unsigned.uint -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushvalue} [lua_pushvalue]} *)
  val pushvalue : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_pushvfstring} [lua_pushvfstring]} *)
  val pushvfstring : State.t ptr -> string -> unit ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawequal} [lua_rawequal]} *)
  val rawequal : State.t ptr -> int -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawget} [lua_rawget]} *)
  val rawget : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawgeti} [lua_rawgeti]} *)
  val rawgeti : State.t ptr -> int -> Ptrdiff.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawgetp} [lua_rawgetp]} *)
  val rawgetp : State.t ptr -> int -> unit ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawlen} [lua_rawlen]} *)
  val rawlen : State.t ptr -> int -> Unsigned.size_t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawset} [lua_rawset]} *)
  val rawset : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_rawsetp} [lua_rawsetp]} *)
  val rawsetp : State.t ptr -> int -> unit ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_register} [lua_register]} *)
  val register : State.t ptr -> string -> CFunction.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_remove} [lua_remove]} *)
  val remove : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_replace} [lua_replace]} *)
  val replace : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_resume} [lua_resume]} *)
  val resume : State.t ptr -> State.t ptr -> int -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setallocf} [lua_setallocf]} *)
  val setallocf : State.t ptr -> Alloc.t -> State.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setfield} [lua_setfield]} *)
  val setfield : State.t ptr -> int -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setglobal} [lua_setglobal]} *)
  val setglobal : State.t ptr -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setmetatable} [lua_setmetatable]} *)
  val setmetatable : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_settable} [lua_settable]} *)
  val settable : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_settop} [lua_settop]} *)
  val settop : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setuservalue} [lua_setuservalue]} *)
  val setuservalue : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_status} [lua_status]} *)
  val status : State.t ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_toboolean} [lua_toboolean]} *)
  val toboolean : State.t ptr -> int -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tocfunction} [lua_tocfunction]} *)
  val tocfunction : State.t ptr -> int -> CFunction.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tointeger} [lua_tointeger]} *)
  val tointeger : State.t ptr -> int -> Ptrdiff.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tointegerx} [lua_tointegerx]} *)
  val tointegerx : State.t ptr -> int -> int ptr -> Ptrdiff.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tolstring} [lua_tolstring]} *)
  val tolstring : State.t ptr -> int -> Unsigned.size_t ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tonumber} [lua_tonumber]} *)
  val tonumber : State.t ptr -> int -> float

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tonumberx} [lua_tonumberx]} *)
  val tonumberx : State.t ptr -> int -> int ptr -> float

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_topointer} [lua_topointer]} *)
  val topointer : State.t ptr -> int -> State.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tostring} [lua_tostring]} *)
  val tostring : State.t ptr -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tothread} [lua_tothread]} *)
  val tothread : State.t ptr -> int -> State.t ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tounsigned} [lua_tounsigned]} *)
  val tounsigned : State.t ptr -> int -> Unsigned.uint

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_tounsignedx} [lua_tounsignedx]} *)
  val tounsignedx : State.t ptr -> int -> int ptr -> Unsigned.uint

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_touserdata} [lua_touserdata]} *)
  val touserdata : State.t ptr -> int -> State.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_type} [lua_type]} *)
  val type_ : State.t ptr -> int -> Ltype.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_typename} [lua_typename]} *)
  val typename : State.t ptr -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_upvalueindex} [lua_upvalueindex]} *)
  val upvalueindex : int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_version} [lua_version]} *)
  val version : State.t ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_xmem} [lua_xmem]} *)
  val xmem : State.t ptr -> State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_yield} [lua_yield]} *)
  val yield : State.t ptr -> int -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_yieldk} [lua_yieldk]} *)
  val yieldk : State.t ptr -> int -> int -> CFunction.t -> Code.t

  (** {2 Debug} *)

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_gethook} [lua_gethook]} *)
  val gethook : State.t ptr -> Hook.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_gethookmask} [lua_gethookmask]} *)
  val gethookmask : State.t ptr -> Mask.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_gethookcount} [lua_gethookcount]} *)
  val gethookcount : State.t ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getinfo} [lua_getinfo]} *)
  val getinfo : State.t ptr -> string -> Debug.t ptr -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getlocal} [lua_getlocal]} *)
  val getlocal : State.t ptr -> Debug.t ptr -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getstack} [lua_getstack]} *)
  val getstack : State.t ptr -> int -> Debug.t ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_getupvalue} [lua_getupvalue]} *)
  val getupvalue : State.t ptr -> int -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_sethook} [lua_sethook]} *)
  val sethook : State.t ptr -> Hook.t -> int -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setlocal} [lua_setlocal]} *)
  val setlocal : State.t ptr -> Debug.t ptr -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_setupvalue} [lua_setupvalue]} *)
  val setupvalue : State.t ptr -> int -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_upvalueid} [lua_upvalueid]} *)
  val upvalueid : State.t ptr -> int -> int -> unit ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#lua_upvaluejoin} [lua_upvaluejoin]} *)
  val upvaluejoin : State.t ptr -> int -> int -> int -> int -> unit

  (** {2 Auxiliary Functions} *)

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_addchar} [luaL_addchar]} *)
  val addchar : Buffer.t ptr -> char -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_addlstring} [luaL_addlstring]} *)
  val addlstring : Buffer.t ptr -> string -> Unsigned.size_t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_addsize} [luaL_addsize]} *)
  val addsize : Buffer.t ptr -> Unsigned.size_t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_addstring} [luaL_addstring]} *)
  val addstring : Buffer.t ptr -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_addvalue} [luaL_addvalue]} *)
  val addvalue : Buffer.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_argcheck} [luaL_argcheck]} *)
  val argcheck : State.t ptr -> int -> int -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_argerror} [luaL_argerror]} *)
  val argerror : State.t ptr -> int -> string -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_buffinit} [luaL_buffinit]} *)
  val buffinit : State.t ptr -> Buffer.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_buffinitsize} [luaL_buffinitsize]} *)
  val buffinitsize : State.t ptr -> Buffer.t ptr -> Unsigned.size_t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_callmeta} [luaL_callmeta]} *)
  val callmeta : State.t ptr -> int -> string -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkany} [luaL_checkany]} *)
  val checkany : State.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkinteger} [luaL_checkinteger]} *)
  val checkinteger : State.t ptr -> int -> Ptrdiff.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkint} [luaL_checkint]} *)
  val checkint : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checklong} [luaL_checklong]} *)
  val checklong : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checklstring} [luaL_checklstring]} *)
  val checklstring : State.t ptr -> int -> Unsigned.size_t ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkoption} [luaL_checkoption]} *)
  val checkoption : State.t ptr -> int -> string -> string ptr -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checknumber} [luaL_checknumber]} *)
  val checknumber : State.t ptr -> int -> float

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkstack} [luaL_checkstack]} *)
  val checkstack' : State.t ptr -> int -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkstring} [luaL_checkstring]} *)
  val checkstring : State.t ptr -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checktype} [luaL_checktype]} *)
  val checktype : State.t ptr -> int -> Ltype.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkudata} [luaL_checkudata]} *)
  val checkudata : State.t ptr -> int -> string -> unit ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkunsigned} [luaL_checkunsigned]} *)
  val checkunsigned : State.t ptr -> int -> Unsigned.uint

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_checkversion} [luaL_checkversion]} *)
  val checkversion : State.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_dofile} [luaL_dofile]} *)
  val dofile : State.t ptr -> string -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_dostring} [luaL_dostring]} *)
  val dostring : State.t ptr -> string -> bool

  (** Wrapper for {{:https://www.lua.org/manual/5.2/manual.html#luaL_error} [luaL_error]}.

      [ptr lua_State -> string -> string list -> int -> int] *)
  val error' : State.t ptr -> string -> string ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_execresult} [luaL_execresult]} *)
  val execresult : State.t ptr -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_fileresult} [luaL_fileresult]} *)
  val fileresult : State.t ptr -> int -> string -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_getmetafield} [luaL_getmetafield]} *)
  val getmetafield : State.t ptr -> int -> string -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_getmetatable} [luaL_getmetatable]} *)
  val getmetatable' : State.t ptr -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_getsubtable} [luaL_getsubtable]} *)
  val getsubtable : State.t ptr -> int -> string -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_gsub} [luaL_gsub]} *)
  val gsub : State.t ptr -> string -> string -> string -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_len} [luaL_len]} *)
  val len' : State.t ptr -> int -> Unsigned.size_t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_loadbufferx} [luaL_loadbufferx]} *)
  val loadbufferx : State.t ptr -> string -> Unsigned.size_t -> string -> string -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_loadbuffer} [luaL_loadbuffer]} *)
  val loadbuffer : State.t ptr -> string -> Unsigned.size_t -> string -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_loadfile} [luaL_loadfile]} *)
  val loadfile : State.t ptr -> string -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_loadfilex} [luaL_loadfilex]} *)
  val loadfilex : State.t ptr -> string -> string -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_loadstring} [luaL_loadstring]} *)
  val loadstring : State.t ptr -> string -> Code.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_newlib} [luaL_newlib]} *)
  val newlib : State.t ptr -> Reg.t ptr -> unit

  (** Wrapper for  {{:https://www.lua.org/manual/5.2/manual.html#luaL_newlibtable} [luaL_newlibtable]}.

      [ptr lua_State -> ptr luaL_Reg -> int -> unit] *)
  val newlibtable : State.t ptr -> Reg.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_newmetatable} [luaL_newmetatable]} *)
  val newmetatable : State.t ptr -> string -> bool

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_newstate} [luaL_newstate]} *)
  val newstate' : unit -> State.t ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_openlibs} [luaL_openlibs]} *)
  val open_libs : State.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optint} [luaL_optint]} *)
  val optint : State.t ptr -> int -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optinteger} [luaL_optinteger]} *)
  val optinteger : State.t ptr -> int -> Ptrdiff.t -> Ptrdiff.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optlong} [luaL_optlong]} *)
  val optlong : State.t ptr -> int -> int -> int

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optlstring} [luaL_optlstring]} *)
  val optlstring : State.t ptr -> int -> string -> Unsigned.size_t ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optnumber} [luaL_optnumber]} *)
  val optnumber : State.t ptr -> int -> float -> float

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optstring} [luaL_optstring]} *)
  val optstring : State.t ptr -> int -> string -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_optunsigned} [luaL_optunsigned]} *)
  val optunsigned : State.t ptr -> int -> Unsigned.uint -> Unsigned.uint

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_prepbuffer} [luaL_prepbuffer]} *)
  val prepbuffer : Buffer.t ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_prepsize} [luaL_prepsize]} *)
  val prepbuffsize : Buffer.t ptr -> Unsigned.size_t -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_pushresult} [luaL_pushresult]} *)
  val pushresult : Buffer.t ptr -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_pushresultsize} [luaL_pushresultsize]} *)
  val pushresultsize : Buffer.t ptr -> Unsigned.size_t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_ref} [luaL_ref]} *)
  val ref : State.t ptr -> int -> Ref.t

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_requiref} [luaL_requiref]} *)
  val requiref : State.t ptr -> string -> CFunction.t -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_setfuncs} [luaL_setfuncs]} *)
  val setfuncs : State.t ptr -> Reg.t ptr -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_setmetatable} [luaL_setmetatable]} *)
  val setmetatable' : State.t ptr -> string -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_testudata} [luaL_testudata]} *)
  val testudata : State.t ptr -> int -> string -> unit ptr

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_tolstring} [luaL_tolstring]} *)
  val tolstring' : State.t ptr -> int -> Unsigned.size_t ptr -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_traceback} [luaL_traceback]} *)
  val traceback : State.t ptr -> State.t ptr -> string -> int -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_typename} [luaL_typename]} *)
  val typename' : State.t ptr -> int -> string

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_unref} [luaL_unref]} *)
  val unref : State.t ptr -> int -> Ref.t -> unit

  (** {{:https://www.lua.org/manual/5.2/manual.html#luaL_where} [luaL_where]} *)
  val where : State.t ptr -> int -> unit
end
