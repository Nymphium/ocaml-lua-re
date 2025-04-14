open Ctypes_static

module Types : sig
  module Const : sig
    val version_num : int
  end

  val number : float typ
  val int : int typ
  val unsigned : Unsigned.UInt.t typ
  val integer : Ctypes.Ptrdiff.t typ
  val lu_byte : Unsigned.UChar.t typ

  module State : sig
    type t

    val t : t typ
  end

  module Callinfo : sig
    type t

    val t : t typ
  end

  module Buffer : sig
    type t

    val t : t Ctypes.structure typ
    val b : (string, t Ctypes.structure) field
    val size : (Unsigned.size_t, t Ctypes.structure) field
    val n : (Unsigned.size_t, t Ctypes.structure) field
    val l : (State.t, t Ctypes.structure) field
    val initb : (string, t Ctypes.structure) field
  end

  module Alloc : sig
    type t =
      (unit ptr -> unit ptr -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> unit ptr)
        static_funptr

    val t : t typ
  end

  module CFunction : sig
    type t = (State.t ptr -> int) static_funptr

    val t : t typ
  end

  module Reader : sig
    type t = (State.t ptr -> unit ptr -> Unsigned.Size_t.t ptr -> string) static_funptr

    val t : t typ
  end

  module Writer : sig
    type t = (State.t ptr -> unit ptr -> Unsigned.Size_t.t -> unit ptr) static_funptr

    val t : t typ
  end

  module Reg : sig
    type t

    val t : t Ctypes.structure typ
    val name : (string, t Ctypes.structure) field
    val func : ((State.t ptr -> int) static_funptr, t Ctypes.structure) field
  end

  module Debug : sig
    type t

    val t : t Ctypes.structure typ
    val event : (int, t Ctypes.structure) field
    val name : (string, t Ctypes.structure) field
    val namewhat : (string, t Ctypes.structure) field
    val what : (string, t Ctypes.structure) field
    val source : (string, t Ctypes.structure) field
    val currentline : (int, t Ctypes.structure) field
    val linedefined : (int, t Ctypes.structure) field
    val lastlinedefined : (int, t Ctypes.structure) field
    val nups : (Unsigned.uchar, t Ctypes.structure) field
    val nparams : (Unsigned.uchar, t Ctypes.structure) field
    val isvararg : (char, t Ctypes.structure) field
    val istailcall : (char, t Ctypes.structure) field
    val short_src : (string, t Ctypes.structure) field
    val i_ci : (unit ptr ptr, t Ctypes.structure) field
  end

  module Op : sig
    val add : int
    val sub : int
    val mul : int
    val div : int
    val mod_ : int
    val pow : int
    val eq : int
    val lt : int
    val le : int
  end

  module Gc : sig
    val stop : int
    val restart : int
    val collect : int
    val count : int
    val countb : int
    val step : int
    val setpause : int
    val setstepmul : int
    val setmajorinc : int
    val isrunning : int
    val inc : int
    val gen : int
  end

  module Hook : sig
    val call : int
    val ret : int
    val line : int
    val count : int
    val tailcall : int

    type t = (unit ptr ptr -> Debug.t Ctypes.structure ptr -> unit) static_funptr

    val t : t typ
  end

  module Mask : sig
    val call : int
    val ret : int
    val line : int
    val count : int
  end
end

module Functions : sig
  open Types

  module Const : sig
    val version : unit -> string
    val version_major : unit -> string
    val version_minor : unit -> string
    val version_release : unit -> string
    val release : unit -> string
    val copyright : unit -> string
    val authors : unit -> string
    val signature : unit -> string
  end

  val absindex : State.t ptr -> int -> int
  val arith : State.t ptr -> int -> unit

  val atpanic
    :  State.t ptr
    -> (State.t ptr -> int) static_funptr
    -> (State.t ptr -> int) static_funptr

  val call : State.t ptr -> int -> int -> unit

  val callk
    :  State.t ptr
    -> int
    -> int
    -> int
    -> (State.t ptr -> int) static_funptr
    -> unit

  val checkstack : State.t ptr -> int -> int
  val close : State.t ptr -> unit
  val compare : State.t ptr -> int -> int -> int -> int
  val concat : State.t ptr -> int -> unit
  val copy : State.t ptr -> int -> int -> unit
  val createtable : State.t ptr -> int -> int -> unit
  val dump : State.t ptr -> (State.t ptr -> int) static_funptr -> unit ptr -> int
  val error : State.t ptr -> int
  val gc : State.t ptr -> int -> int -> int
  val getallocf : State.t ptr -> unit ptr ptr -> Alloc.t
  val getctx : State.t ptr -> int ptr -> int
  val getfield : State.t ptr -> int -> string -> unit
  val getglobal : State.t ptr -> string -> unit
  val getmetatable : State.t ptr -> int -> int
  val gettable : State.t ptr -> int -> unit
  val gettop : State.t ptr -> int
  val getuservalue : State.t ptr -> int -> unit
  val insert : State.t ptr -> int -> unit
  val isboolean : State.t ptr -> int -> int
  val iscfunction : State.t ptr -> int -> int
  val islightuserdata : State.t ptr -> int -> int
  val isnil : State.t ptr -> int -> int
  val isnone : State.t ptr -> int -> int
  val isnoneornil : State.t ptr -> int -> int
  val isnumber : State.t ptr -> int -> int
  val isstring : State.t ptr -> int -> int
  val istable : State.t ptr -> int -> int
  val isthread : State.t ptr -> int -> int
  val isuserdata : State.t ptr -> int -> int
  val len : State.t ptr -> int -> unit

  val load
    :  State.t ptr
    -> (State.t ptr -> State.t -> Unsigned.size_t ptr -> string) static_funptr
    -> State.t
    -> string
    -> string
    -> int

  val newstate
    :  (State.t -> State.t -> Unsigned.size_t -> Unsigned.size_t -> State.t) static_funptr
    -> State.t
    -> State.t ptr

  val newstate' : unit -> State.t ptr
  val newtable : State.t ptr -> unit
  val newthread : State.t ptr -> State.t ptr
  val newuserdata : State.t ptr -> Unsigned.size_t -> unit
  val next : State.t ptr -> int -> int
  val pcall : State.t ptr -> int -> int -> int -> int
  val pcallk : State.t ptr -> int -> int -> int -> int -> CFunction.t -> int
  val pop : State.t ptr -> int -> unit
  val pushboolean : State.t ptr -> int -> unit
  val pushcclosure : State.t ptr -> CFunction.t -> int -> unit
  val pushcfunction : State.t ptr -> CFunction.t -> unit
  val pushfstring : State.t ptr -> string -> string
  val pushglobaltable : State.t ptr -> unit
  val pushinteger : State.t ptr -> Lua__c_generated_types.Ptrdiff.t -> unit
  val pushlightuserdata : State.t ptr -> State.t -> unit
  val pushlstring : State.t ptr -> string -> Unsigned.size_t -> string
  val pushniil : State.t ptr -> unit
  val pushnumber : State.t ptr -> float -> unit
  val pushstring : State.t ptr -> string -> string
  val pushthread : State.t ptr -> int
  val pushunsigned : State.t ptr -> Unsigned.uint -> unit
  val pushvalue : State.t ptr -> int -> unit
  val pushvfstring : State.t ptr -> string -> State.t -> string
  val rawequal : State.t ptr -> int -> int -> int
  val rawget : State.t ptr -> int -> unit
  val rawgeti : State.t ptr -> int -> Lua__c_generated_types.Ptrdiff.t -> unit
  val rawgetp : State.t ptr -> int -> State.t -> unit
  val rawlen : State.t ptr -> int -> Unsigned.size_t
  val rawset : State.t ptr -> int -> unit
  val rawsetp : State.t ptr -> int -> State.t -> unit
  val register : State.t ptr -> string -> CFunction.t -> unit
  val remove : State.t ptr -> int -> unit
  val replace : State.t ptr -> int -> unit
  val resume : State.t ptr -> State.t ptr -> int -> int

  val setallocf
    :  State.t ptr
    -> (State.t -> State.t -> Unsigned.size_t -> Unsigned.size_t -> State.t) static_funptr
    -> State.t
    -> unit

  val setfield : State.t ptr -> int -> string -> unit
  val setglobal : State.t ptr -> string -> unit
  val setmetatable : State.t ptr -> int -> int
  val settable : State.t ptr -> int -> unit
  val settop : State.t ptr -> int -> unit
  val setuservalue : State.t ptr -> int -> unit
  val status : State.t ptr -> int
  val toboolean : State.t ptr -> int -> int
  val tocfunction : State.t ptr -> int -> CFunction.t
  val tointeger : State.t ptr -> int -> Lua__c_generated_types.Ptrdiff.t
  val tointegerx : State.t ptr -> int -> int ptr -> Lua__c_generated_types.Ptrdiff.t
  val tolstring : State.t ptr -> int -> Unsigned.size_t ptr -> string
  val tonumber : State.t ptr -> int -> float
  val tonumberx : State.t ptr -> int -> int ptr -> float
  val topointer : State.t ptr -> int -> State.t
  val tostring : State.t ptr -> int -> string
  val tothread : State.t ptr -> int -> State.t ptr
  val tounsigned : State.t ptr -> int -> Unsigned.uint
  val tounsignedx : State.t ptr -> int -> int ptr -> Unsigned.uint
  val touserdata : State.t ptr -> int -> State.t
  val type_ : State.t ptr -> int -> int
  val typename : State.t ptr -> int -> string
  val upvalueindex : int -> int
  val version : State.t ptr -> string
  val xmem : State.t ptr -> State.t ptr -> int -> unit
  val yield : State.t ptr -> int -> int
  val yieldk : State.t ptr -> int -> int -> CFunction.t -> int
  val gethook : State.t ptr -> Hook.t
  val gethookmask : State.t ptr -> int
  val gethookcount : State.t ptr -> int
  val getinfo : State.t ptr -> string -> Debug.t Ctypes.structure ptr -> int
  val getlocal : State.t ptr -> Debug.t Ctypes.structure ptr -> int -> string
  val getstack : State.t ptr -> int -> Debug.t Ctypes.structure ptr -> int
  val getupvalue : State.t ptr -> int -> int -> string
  val sethook : State.t ptr -> Hook.t -> int -> int -> unit
  val setlocal : State.t ptr -> Debug.t Ctypes.structure ptr -> int -> string
  val setupvalue : State.t ptr -> int -> int -> string
  val upvalueid : State.t ptr -> int -> int -> State.t
  val upvaluejoin : State.t ptr -> int -> int -> int -> int -> unit
  val addchar : Buffer.t Ctypes.structure ptr -> char -> unit
  val addlstring : Buffer.t Ctypes.structure ptr -> string -> Unsigned.size_t -> unit
  val addsize : Buffer.t Ctypes.structure ptr -> Unsigned.size_t -> unit
  val addstring : Buffer.t Ctypes.structure ptr -> string -> unit
  val addvalue : Buffer.t Ctypes.structure ptr -> unit
  val argcheck : State.t ptr -> int -> int -> string -> unit
  val argerror : State.t ptr -> int -> string -> int
  val buffinit : State.t ptr -> Buffer.t Ctypes.structure ptr -> unit

  val buffinitsize
    :  State.t ptr
    -> Buffer.t Ctypes.structure ptr
    -> Unsigned.size_t
    -> unit

  val callmeta : State.t ptr -> int -> string -> int
  val checkany : State.t ptr -> int -> unit
  val checkinteger : State.t ptr -> int -> Lua__c_generated_types.Ptrdiff.t
  val checkint : State.t ptr -> int -> int
  val checklong : State.t ptr -> int -> int
  val checklstring : State.t ptr -> int -> Unsigned.size_t ptr -> string
  val checkoption : State.t ptr -> int -> string -> string ptr -> int
  val checknumber : State.t ptr -> int -> float
  val checkstack' : State.t ptr -> int -> string -> unit
  val checkstring : State.t ptr -> int -> string
  val checktype : State.t ptr -> int -> int -> unit
  val checkudata : State.t ptr -> int -> string -> State.t
  val checkunsigned : State.t ptr -> int -> Unsigned.uint
  val checkversion : State.t ptr -> unit
  val dofile : State.t ptr -> string -> int
  val dostring : State.t ptr -> string -> int
  val error' : State.t ptr -> string -> string ptr -> int -> int
  val execresult : State.t ptr -> int -> int
  val fileresult : State.t ptr -> int -> string -> int
  val getmetafield : State.t ptr -> int -> string -> int
  val getmetatable' : State.t ptr -> string -> unit
  val getsubtable : State.t ptr -> int -> string -> int
  val gsub : State.t ptr -> string -> string -> string -> string
  val len' : State.t ptr -> int -> Unsigned.size_t
  val loadbufferx : State.t ptr -> string -> Unsigned.size_t -> string -> string -> int
  val loadbuffer : State.t ptr -> string -> Unsigned.size_t -> string -> int
  val loadfile : State.t ptr -> string -> int
  val loadfilex : State.t ptr -> string -> string -> int
  val loadstring : State.t ptr -> string -> int
  val newlib : State.t ptr -> Reg.t Ctypes.structure ptr -> unit
  val newlibtable : State.t ptr -> Reg.t Ctypes.structure ptr -> int -> unit
  val newmetatable : State.t ptr -> string -> int
  val open_libs : State.t ptr -> unit
  val optint : State.t ptr -> int -> int -> int
  val optinteger : State.t ptr -> int -> Ctypes.Ptrdiff.t -> Ctypes.Ptrdiff.t
  val optlong : State.t ptr -> int -> int -> int
  val optlstring : State.t ptr -> int -> string -> Unsigned.size_t ptr -> string
  val optnumber : State.t ptr -> int -> float -> float
  val optstring : State.t ptr -> int -> string -> string
  val optunsigned : State.t ptr -> int -> Unsigned.uint -> Unsigned.uint
  val prepbuffer : Buffer.t Ctypes.structure ptr -> string
  val prepbuffsize : Buffer.t Ctypes.structure ptr -> Unsigned.size_t -> string
  val pushresult : Buffer.t Ctypes.structure ptr -> unit
  val pushresultsize : Buffer.t Ctypes.structure ptr -> Unsigned.size_t -> unit
  val ref : State.t ptr -> int -> int
  val requiref : State.t ptr -> string -> CFunction.t -> int -> unit
  val setfuncs : State.t ptr -> Reg.t Ctypes.structure ptr -> int -> unit
  val setmetatable' : State.t ptr -> string -> unit
  val testudata : State.t ptr -> int -> string -> State.t
  val tolstring' : State.t ptr -> int -> Unsigned.size_t ptr -> string
  val traceback : State.t ptr -> State.t ptr -> string -> int -> unit
  val typename' : State.t ptr -> int -> string
  val unref : State.t ptr -> int -> int -> unit
  val where : State.t ptr -> int -> unit
end
