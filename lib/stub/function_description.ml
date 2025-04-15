open Ctypes

module Functions (F : Ctypes.FOREIGN) = struct
  open F
  module T = Types_generated

  open struct
    let ( @:: ) name t = F.foreign name t
  end

  module Const = struct
    let version = "lua_version_helper" @:: void @-> returning @@ string
    let version_major = "lua_version_major_helper" @:: void @-> returning string
    let version_minor = "lua_version_minor_helper" @:: void @-> returning string
    let version_release = "lua_version_release_helper" @:: void @-> returning string
    let release = "lua_release_helper" @:: void @-> returning string
    let copyright = "lua_copyright_helper" @:: void @-> returning string
    let authors = "lua_authors_helper" @:: void @-> returning string
    let signature = "lua_signature_helper" @:: void @-> returning string
  end

  let absindex = "lua_absindex" @:: ptr T.State.t @-> int @-> returning int
  let arith = "lua_arith" @:: ptr T.State.t @-> T.Op.t @-> returning void

  let atpanic =
    "lua_atpanic" @:: ptr T.State.t @-> T.CFunction.t @-> returning T.CFunction.t
  ;;

  let call = "lua_call" @:: ptr T.State.t @-> int @-> int @-> returning void

  let callk =
    "lua_callk"
    @:: ptr T.State.t
    @-> int
    @-> int
    @-> int
    @-> T.CFunction.t
    @-> returning void
  ;;

  let checkstack = "lua_checkstack" @:: ptr T.State.t @-> int @-> returning bool
  let close = "lua_close" @:: ptr T.State.t @-> returning void

  let compare =
    "lua_compare" @:: ptr T.State.t @-> int @-> int @-> T.Op.Comp.t @-> returning int
  ;;

  let concat = "lua_concat" @:: ptr T.State.t @-> int @-> returning void
  let copy = "lua_copy" @:: ptr T.State.t @-> int @-> int @-> returning void
  let createtable = "lua_createtable" @:: ptr T.State.t @-> int @-> int @-> returning void

  let dump =
    "lua_dump" @:: ptr T.State.t @-> T.CFunction.t @-> ptr void @-> returning T.Code.t
  ;;

  let error = "lua_error" @:: ptr T.State.t @-> returning int
  let gc = "lua_gc" @:: ptr T.State.t @-> T.Gc.t @-> int @-> returning int

  let getallocf =
    "lua_getallocf" @:: ptr T.State.t @-> (ptr @@ ptr void) @-> returning T.Alloc.t
  ;;

  let getctx = "lua_getctx" @:: ptr T.State.t @-> ptr int @-> returning T.Code.t
  let getfield = "lua_getfield" @:: ptr T.State.t @-> int @-> string @-> returning void
  let getglobal = "lua_getglobal" @:: ptr T.State.t @-> string @-> returning void
  let getmetatable = "lua_getmetatable" @:: ptr T.State.t @-> int @-> returning int
  let gettable = "lua_gettable" @:: ptr T.State.t @-> int @-> returning void
  let gettop = "lua_gettop" @:: ptr T.State.t @-> returning int
  let getuservalue = "lua_getuservalue" @:: ptr T.State.t @-> int @-> returning void
  let insert = "lua_insert" @:: ptr T.State.t @-> int @-> returning void
  let isboolean = "lua_isboolean" @:: ptr T.State.t @-> int @-> returning bool

  (*let isfunction = "lua_isfunction" @:: ptr T.State.t @-> int @-> returning int*)
  let iscfunction = "lua_isfunction" @:: ptr T.State.t @-> int @-> returning bool
  let islightuserdata = "lua_islightuserdata" @:: ptr T.State.t @-> int @-> returning bool
  let isnil = "lua_isnil" @:: ptr T.State.t @-> int @-> returning bool
  let isnone = "lua_isnone" @:: ptr T.State.t @-> int @-> returning bool
  let isnoneornil = "lua_isnoneornil" @:: ptr T.State.t @-> int @-> returning bool
  let isnumber = "lua_isnumber" @:: ptr T.State.t @-> int @-> returning bool
  let isstring = "lua_isstring" @:: ptr T.State.t @-> int @-> returning bool
  let istable = "lua_istable" @:: ptr T.State.t @-> int @-> returning bool
  let isthread = "lua_isthread" @:: ptr T.State.t @-> int @-> returning bool
  let isuserdata = "lua_isuserdata" @:: ptr T.State.t @-> int @-> returning bool
  let len = "lua_len" @:: ptr T.State.t @-> int @-> returning void

  let load =
    "lua_load"
    @:: ptr T.State.t
    @-> T.Reader.t
    @-> ptr void
    @-> string
    @-> string
    @-> returning T.Code.t
  ;;

  let newstate = "lua_newstate" @:: T.Alloc.t @-> ptr void @-> returning @@ ptr T.State.t
  let newstate' = "luaL_newstate" @:: void @-> returning @@ ptr T.State.t
  let newtable = "lua_newtable" @:: ptr T.State.t @-> returning void
  let newthread = "lua_newthread" @:: ptr T.State.t @-> returning @@ ptr T.State.t
  let newuserdata = "lua_newuserdata" @:: ptr T.State.t @-> size_t @-> returning void
  let next = "lua_next" @:: ptr T.State.t @-> int @-> returning int
  let pcall = "lua_pcall" @:: ptr T.State.t @-> int @-> int @-> int @-> returning T.Code.t

  let pcallk =
    "lua_pcallk"
    @:: ptr T.State.t
    @-> int
    @-> int
    @-> int
    @-> int
    @-> T.CFunction.t
    @-> returning T.Code.t
  ;;

  let pop = "lua_pop" @:: ptr T.State.t @-> int @-> returning void
  let pushboolean = "lua_pushboolean" @:: ptr T.State.t @-> int @-> returning void

  let pushcclosure =
    "lua_pushcclosure" @:: ptr T.State.t @-> T.CFunction.t @-> int @-> returning void
  ;;

  let pushcfunction =
    "lua_pushcfunction" @:: ptr T.State.t @-> T.CFunction.t @-> returning void
  ;;

  (** XXX: variadic arguments *)
  let pushfstring = "lua_pushfstring" @:: ptr T.State.t @-> string @-> returning @@ string

  let pushglobaltable = "lua_pushglobaltable" @:: ptr T.State.t @-> returning void
  let pushinteger = "lua_pushinteger" @:: ptr T.State.t @-> T.integer @-> returning void

  let pushlightuserdata =
    "lua_pushlightuserdata" @:: ptr T.State.t @-> ptr void @-> returning void
  ;;

  (*let pushliteral =*)
  (*  "lua_pushliteral" @:: ptr T.State.t @-> string @-> returning @@ string*)
  (*;;*)

  let pushlstring =
    "lua_pushlstring" @:: ptr T.State.t @-> string @-> size_t @-> returning @@ string
  ;;

  let pushniil = "lua_pushnil" @:: ptr T.State.t @-> returning void
  let pushnumber = "lua_pushnumber" @:: ptr T.State.t @-> T.number @-> returning void
  let pushstring = "lua_pushstring" @:: ptr T.State.t @-> string @-> returning @@ string
  let pushthread = "lua_pushthread" @:: ptr T.State.t @-> returning int

  let pushunsigned =
    "lua_pushunsigned" @:: ptr T.State.t @-> T.unsigned @-> returning void
  ;;

  let pushvalue = "lua_pushvalue" @:: ptr T.State.t @-> int @-> returning void

  (** XXX: va_list instead ptr void *)
  let pushvfstring =
    "lua_pushvfstring" @:: ptr T.State.t @-> string @-> ptr void @-> returning @@ string
  ;;

  let rawequal = "lua_rawequal" @:: ptr T.State.t @-> int @-> int @-> returning T.bool
  let rawget = "lua_rawget" @:: ptr T.State.t @-> int @-> returning void
  let rawgeti = "lua_rawgeti" @:: ptr T.State.t @-> int @-> T.integer @-> returning void
  let rawgetp = "lua_rawgetp" @:: ptr T.State.t @-> int @-> ptr void @-> returning void
  let rawlen = "lua_rawlen" @:: ptr T.State.t @-> int @-> returning size_t
  let rawset = "lua_rawset" @:: ptr T.State.t @-> int @-> returning void
  let rawsetp = "lua_rawsetp" @:: ptr T.State.t @-> int @-> ptr void @-> returning void

  let register =
    "lua_register" @:: ptr T.State.t @-> string @-> T.CFunction.t @-> returning void
  ;;

  let remove = "lua_remove" @:: ptr T.State.t @-> int @-> returning void
  let replace = "lua_replace" @:: ptr T.State.t @-> int @-> returning void

  let resume =
    "lua_resume" @:: ptr T.State.t @-> ptr T.State.t @-> int @-> returning T.Code.t
  ;;

  let setallocf =
    "lua_setallocf" @:: ptr T.State.t @-> T.Alloc.t @-> ptr void @-> returning void
  ;;

  let setfield = "lua_setfield" @:: ptr T.State.t @-> int @-> string @-> returning void
  let setglobal = "lua_setglobal" @:: ptr T.State.t @-> string @-> returning void
  let setmetatable = "lua_setmetatable" @:: ptr T.State.t @-> int @-> returning int
  let settable = "lua_settable" @:: ptr T.State.t @-> int @-> returning void
  let settop = "lua_settop" @:: ptr T.State.t @-> int @-> returning void
  let setuservalue = "lua_setuservalue" @:: ptr T.State.t @-> int @-> returning void
  let status = "lua_status" @:: ptr T.State.t @-> returning T.Code.t
  let toboolean = "lua_toboolean" @:: ptr T.State.t @-> int @-> returning T.bool

  let tocfunction =
    "lua_tocfunction" @:: ptr T.State.t @-> int @-> returning T.CFunction.t
  ;;

  let tointeger = "lua_tointeger" @:: ptr T.State.t @-> int @-> returning T.integer

  let tointegerx =
    "lua_tointegerx" @:: ptr T.State.t @-> int @-> ptr int @-> returning T.integer
  ;;

  let tolstring =
    "lua_tolstring" @:: ptr T.State.t @-> int @-> ptr size_t @-> returning string
  ;;

  let tonumber = "lua_tonumber" @:: ptr T.State.t @-> int @-> returning T.number

  let tonumberx =
    "lua_tonumberx" @:: ptr T.State.t @-> int @-> ptr int @-> returning T.number
  ;;

  let topointer = "lua_topointer" @:: ptr T.State.t @-> int @-> returning @@ ptr void
  let tostring = "lua_tostring" @:: ptr T.State.t @-> int @-> returning @@ string
  let tothread = "lua_tothread" @:: ptr T.State.t @-> int @-> returning @@ ptr T.State.t
  let tounsigned = "lua_tounsigned" @:: ptr T.State.t @-> int @-> returning T.unsigned

  let tounsignedx =
    "lua_tounsignedx" @:: ptr T.State.t @-> int @-> ptr int @-> returning T.unsigned
  ;;

  let touserdata = "lua_touserdata" @:: ptr T.State.t @-> int @-> returning @@ ptr void
  let type_ = "lua_type" @:: ptr T.State.t @-> int @-> returning T.Ltype.t
  let typename = "lua_typename" @:: ptr T.State.t @-> int @-> returning @@ string
  let upvalueindex = "lua_upvalueindex" @:: int @-> returning int
  let version = "lua_version" @:: ptr T.State.t @-> returning @@ string
  let xmem = "lua_xmove" @:: ptr T.State.t @-> ptr T.State.t @-> int @-> returning void
  let yield = "lua_yield" @:: ptr T.State.t @-> int @-> returning T.Code.t

  let yieldk =
    "lua_yieldk"
    @:: ptr T.State.t
    @-> int
    @-> int
    @-> T.CFunction.t
    @-> returning T.Code.t
  ;;

  let gethook = "lua_gethook" @:: ptr T.State.t @-> returning T.Hook.t
  let gethookmask = "lua_gethookmask" @:: ptr T.State.t @-> returning T.Mask.t
  let gethookcount = "lua_gethookcount" @:: ptr T.State.t @-> returning int

  let getinfo =
    "lua_getinfo" @:: ptr T.State.t @-> string @-> ptr T.Debug.t @-> returning T.Code.t
  ;;

  let getlocal =
    "lua_getlocal" @:: ptr T.State.t @-> ptr T.Debug.t @-> int @-> returning @@ string
  ;;

  let getstack =
    "lua_getstack" @:: ptr T.State.t @-> int @-> ptr T.Debug.t @-> returning int
  ;;

  let getupvalue =
    "lua_getupvalue" @:: ptr T.State.t @-> int @-> int @-> returning @@ string
  ;;

  let sethook =
    "lua_sethook" @:: ptr T.State.t @-> T.Hook.t @-> T.Mask.t @-> int @-> returning int
  ;;

  let setlocal =
    "lua_setlocal" @:: ptr T.State.t @-> ptr T.Debug.t @-> int @-> returning @@ string
  ;;

  let setupvalue =
    "lua_setupvalue" @:: ptr T.State.t @-> int @-> int @-> returning @@ string
  ;;

  let upvalueid =
    "lua_upvalueid" @:: ptr T.State.t @-> int @-> int @-> returning @@ ptr void
  ;;

  let upvaluejoin =
    "lua_upvaluejoin" @:: ptr T.State.t @-> int @-> int @-> int @-> int @-> returning void
  ;;

  let addchar = "luaL_addchar" @:: ptr T.Buffer.t @-> char @-> returning void

  let addlstring =
    "luaL_addlstring" @:: ptr T.Buffer.t @-> string @-> size_t @-> returning void
  ;;

  let addsize = "luaL_addsize" @:: ptr T.Buffer.t @-> size_t @-> returning void
  let addstring = "luaL_addstring" @:: ptr T.Buffer.t @-> string @-> returning void
  let addvalue = "luaL_addvalue" @:: ptr T.Buffer.t @-> returning void

  let argcheck =
    "luaL_argcheck" @:: ptr T.State.t @-> int @-> int @-> string @-> returning void
  ;;

  let argerror = "luaL_argerror" @:: ptr T.State.t @-> int @-> string @-> returning int
  let buffinit = "luaL_buffinit" @:: ptr T.State.t @-> ptr T.Buffer.t @-> returning void

  let buffinitsize =
    "luaL_buffinitsize" @:: ptr T.State.t @-> ptr T.Buffer.t @-> size_t @-> returning void
  ;;

  let callmeta = "luaL_callmeta" @:: ptr T.State.t @-> int @-> string @-> returning bool
  let checkany = "luaL_checkany" @:: ptr T.State.t @-> int @-> returning void
  let checkinteger = "luaL_checkinteger" @:: ptr T.State.t @-> int @-> returning T.integer
  let checkint = "luaL_checkint" @:: ptr T.State.t @-> int @-> returning int
  let checklong = "luaL_checklong" @:: ptr T.State.t @-> int @-> returning int

  let checklstring =
    "luaL_checklstring" @:: ptr T.State.t @-> int @-> ptr size_t @-> returning @@ string
  ;;

  let checkoption =
    "luaL_checkoption"
    @:: ptr T.State.t
    @-> int
    @-> string
    @-> ptr string
    @-> returning int
  ;;

  let checknumber = "luaL_checknumber" @:: ptr T.State.t @-> int @-> returning T.number

  let checkstack' =
    "luaL_checkstack" @:: ptr T.State.t @-> int @-> string @-> returning void
  ;;

  let checkstring = "luaL_checkstring" @:: ptr T.State.t @-> int @-> returning @@ string

  let checktype =
    "luaL_checktype" @:: ptr T.State.t @-> int @-> T.Ltype.t @-> returning void
  ;;

  let checkudata =
    "luaL_checkudata" @:: ptr T.State.t @-> int @-> string @-> returning @@ ptr void
  ;;

  let checkunsigned =
    "luaL_checkunsigned" @:: ptr T.State.t @-> int @-> returning T.unsigned
  ;;

  let checkversion = "luaL_checkversion" @:: ptr T.State.t @-> returning void
  let dofile = "luaL_dofile" @:: ptr T.State.t @-> string @-> returning T.bool
  let dostring = "luaL_dostring" @:: ptr T.State.t @-> string @-> returning T.bool

  (** Wrapper for luaL_error.
      ptr lua_State -> string -> string list -> int -> int *)
  let error' =
    "luaL_error_helper"
    @:: ptr T.State.t
    @-> string
    @-> ptr string
    @-> int
    @-> returning int
  ;;

  let execresult = "luaL_execresult" @:: ptr T.State.t @-> int @-> returning int

  let fileresult =
    "luaL_fileresult" @:: ptr T.State.t @-> int @-> string @-> returning int
  ;;

  let getmetafield =
    "luaL_getmetafield" @:: ptr T.State.t @-> int @-> string @-> returning T.bool
  ;;

  let getmetatable' = "luaL_getmetatable" @:: ptr T.State.t @-> string @-> returning void

  let getsubtable =
    "luaL_getsubtable" @:: ptr T.State.t @-> int @-> string @-> returning bool
  ;;

  let gsub =
    "luaL_gsub" @:: ptr T.State.t @-> string @-> string @-> string @-> returning string
  ;;

  let len' = "luaL_len" @:: ptr T.State.t @-> int @-> returning size_t

  let loadbufferx =
    "luaL_loadbufferx"
    @:: ptr T.State.t
    @-> string
    @-> size_t
    @-> string
    @-> string
    @-> returning T.Code.t
  ;;

  let loadbuffer =
    "luaL_loadbuffer" @:: ptr T.State.t @-> string @-> size_t @-> string @-> returning int
  ;;

  let loadfile = "luaL_loadfile" @:: ptr T.State.t @-> string @-> returning T.Code.t

  let loadfilex =
    "luaL_loadfilex" @:: ptr T.State.t @-> string @-> string @-> returning T.Code.t
  ;;

  let loadstring = "luaL_loadstring" @:: ptr T.State.t @-> string @-> returning T.Code.t
  let newlib = "luaL_newlib" @:: ptr T.State.t @-> ptr T.Reg.t @-> returning void

  let newlibtable =
    "luaL_newlibtable_helper" @:: ptr T.State.t @-> ptr T.Reg.t @-> int @-> returning void
  ;;

  let newmetatable = "luaL_newmetatable" @:: ptr T.State.t @-> string @-> returning T.bool
  let open_libs = "luaL_openlibs" @:: ptr T.State.t @-> returning void
  let optint = "luaL_optint" @:: ptr T.State.t @-> int @-> int @-> returning int

  let optinteger =
    "luaL_optinteger" @:: ptr T.State.t @-> int @-> T.integer @-> returning T.integer
  ;;

  let optlong = "luaL_optlong" @:: ptr T.State.t @-> int @-> int @-> returning int

  let optlstring =
    "luaL_optlstring"
    @:: ptr T.State.t
    @-> int
    @-> string
    @-> ptr size_t
    @-> returning
    @@ string
  ;;

  let optnumber =
    "luaL_optnumber" @:: ptr T.State.t @-> int @-> T.number @-> returning T.number
  ;;

  let optstring =
    "luaL_optstring" @:: ptr T.State.t @-> int @-> string @-> returning @@ string
  ;;

  let optunsigned =
    "luaL_optunsigned" @:: ptr T.State.t @-> int @-> T.unsigned @-> returning T.unsigned
  ;;

  let prepbuffer = "luaL_prepbuffer" @:: ptr T.Buffer.t @-> returning string

  let prepbuffsize =
    "luaL_prepbuffsize" @:: ptr T.Buffer.t @-> size_t @-> returning string
  ;;

  let pushresult = "luaL_pushresult" @:: ptr T.Buffer.t @-> returning void

  let pushresultsize =
    "luaL_pushresultsize" @:: ptr T.Buffer.t @-> size_t @-> returning void
  ;;

  let ref = "luaL_ref" @:: ptr T.State.t @-> int @-> returning T.Ref.t

  let requiref =
    "luaL_requiref"
    @:: ptr T.State.t
    @-> string
    @-> T.CFunction.t
    @-> int
    @-> returning void
  ;;

  let setfuncs =
    "luaL_setfuncs" @:: ptr T.State.t @-> ptr T.Reg.t @-> int @-> returning void
  ;;

  let setmetatable' = "luaL_setmetatable" @:: ptr T.State.t @-> string @-> returning void

  let testudata =
    "luaL_testudata" @:: ptr T.State.t @-> int @-> string @-> returning @@ ptr void
  ;;

  let tolstring' =
    "luaL_tolstring" @:: ptr T.State.t @-> int @-> ptr size_t @-> returning @@ string
  ;;

  let traceback =
    "luaL_traceback"
    @:: ptr T.State.t
    @-> ptr T.State.t
    @-> string
    @-> int
    @-> returning void
  ;;

  let typename' = "luaL_typename" @:: ptr T.State.t @-> int @-> returning @@ string
  let unref = "luaL_unref" @:: ptr T.State.t @-> int @-> T.Ref.t @-> returning void
  let where = "luaL_where" @:: ptr T.State.t @-> int @-> returning void
end
