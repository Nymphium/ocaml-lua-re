open Ctypes

module Types (S : TYPE) = struct
  open S

  type nonrec 'a typ = 'a typ

  open struct
    let ( @:! ) name t = constant name t
    let ( .@:[]<- ) t name typ = field t name typ

    (** just flip original *)
    let typedef' name t = typedef t name
  end

  module Const = struct
    let version_num = "LUA_VERSION_NUM" @:! int
  end

  let number = float
  let int = int
  let unsigned = uint
  let integer = ptrdiff_t
  let lu_byte = uchar

  module State = struct
    type t = unit ptr

    let t : t typ = typedef' "lua_State" @@ ptr void
  end

  module Buffer = struct
    type t

    let t : t structure typ = structure "luaL_Buffer"
    let b = t.@:["b"] <- string
    let size = t.@:["size"] <- size_t
    let n = t.@:["n"] <- size_t
    let l = t.@:["L"] <- State.t

    (** TODO: char[LUAL_BUFFERSIZE] *)
    let initb = t.@:["initb"] <- string

    let () = seal t
    let t = typedef' "luaL_Buffer" @@ t
  end

  module Alloc = struct
    (* NOT abstract type *)
    type t =
      (unit ptr -> unit ptr -> Unsigned.size_t -> Unsigned.size_t -> unit ptr)
        static_funptr

    let t : t typ =
      typedef' "lua_Alloc"
      @@ static_funptr
      @@ ptr void
      @-> ptr void
      @-> size_t
      @-> size_t
      @-> returning
      @@ ptr void
    ;;
  end

  module CFunction = struct
    (* NOT abstract type *)
    type t = (State.t Ctypes_static.ptr -> int) static_funptr

    let t : t typ =
      typedef' "lua_CFunction" @@ static_funptr @@ ptr State.t @-> returning int
    ;;
  end

  module Reader = struct
    (* NOT abstract type *)
    type t =
      (State.t Ctypes_static.ptr
       -> unit Ctypes_static.ptr
       -> Unsigned.size_t Ctypes_static.ptr
       -> string)
        static_funptr

    let t : t typ =
      typedef' "lua_Reader"
      @@ static_funptr
      @@ ptr State.t
      @-> ptr void
      @-> ptr size_t
      @-> returning
      @@ const string
    ;;
  end

  module Writer = struct
    (* NOT abstract type *)
    type t = (State.t ptr -> unit ptr -> Unsigned.size_t -> unit ptr) static_funptr

    let t : t typ =
      typedef' "lua_Writer"
      @@ static_funptr
      @@ ptr State.t
      @-> (const @@ ptr void)
      @-> size_t
      @-> returning
      @@ ptr void
    ;;
  end

  module Reg = struct
    type t

    let t : t structure typ = typedef' "luaL_Reg" @@ structure "luaL_Reg"
    let name = t.@:["name"] <- const string
    let func = t.@:["func"] <- CFunction.t
    let () = seal t
  end

  module Callinfo = struct
    type t = unit ptr

    let t : t typ = ptr void
  end

  module Debug = struct
    type t

    let t' : t structure typ = structure "lua_Debug"
    let event = t'.@:["event"] <- int
    let name = t'.@:["name"] <- const string
    let namewhat = t'.@:["namewhat"] <- const string
    let what = t'.@:["what"] <- const string
    let source = t'.@:["source"] <- const string
    let currentline = t'.@:["currentline"] <- int
    let linedefined = t'.@:["linedefined"] <- int
    let lastlinedefined = t'.@:["lastlinedefined"] <- int
    let nups = t'.@:["nups"] <- uchar
    let nparams = t'.@:["nparams"] <- uchar
    let isvararg = t'.@:["isvararg"] <- char
    let istailcall = t'.@:["istailcall"] <- char
    let short_src = t'.@:["short_src"] <- string
    let i_ci = t'.@:["i_ci"] <- ptr Callinfo.t
    let () = seal t'
    let t = typedef t' "lua_Debug"
  end

  module Op = struct
    let t = int
    let add = "LUA_OPADD" @:! t
    let sub = "LUA_OPSUB" @:! t
    let mul = "LUA_OPMUL" @:! t
    let div = "LUA_OPDIV" @:! t
    let mod_ = "LUA_OPMOD" @:! t
    let pow = "LUA_OPPOW" @:! t
    let eq = "LUA_OPEQ" @:! t
    let lt = "LUA_OPLT" @:! t
    let le = "LUA_OPLE" @:! t
  end

  module Gc = struct
    let t = int
    let stop = "LUA_GCSTOP" @:! t
    let restart = "LUA_GCRESTART" @:! t
    let collect = "LUA_GCCOLLECT" @:! t
    let count = "LUA_GCCOUNT" @:! t
    let countb = "LUA_GCCOUNTB" @:! t
    let step = "LUA_GCSTEP" @:! t
    let setpause = "LUA_GCSETPAUSE" @:! t
    let setstepmul = "LUA_GCSETSTEPMUL" @:! t
    let setmajorinc = "LUA_GCSETMAJORINC" @:! t
    let isrunning = "LUA_GCISRUNNING" @:! t
    let inc = "LUA_GCINC" @:! t
    let gen = "LUA_GCGEN" @:! t
  end

  module Hook = struct
    let t = int
    let call = "LUA_HOOKCALL" @:! t
    let ret = "LUA_HOOKRET" @:! t
    let line = "LUA_HOOKLINE" @:! t
    let count = "LUA_HOOKCOUNT" @:! t
    let tailcall = "LUA_HOOKTAILCALL" @:! t

    (* overwrite *)

    (* NOT abstract type *)
    type t =
      (State.t Ctypes_static.ptr -> Debug.t structure Ctypes_static.ptr -> unit)
        static_funptr

    let t : t typ =
      typedef' "lua_Hook"
      @@ static_funptr
      @@ ptr State.t
      @-> ptr Debug.t
      @-> returning void
    ;;
  end

  module Mask = struct
    let t = int
    let call = "LUA_MASKCALL" @:! t
    let ret = "LUA_MASKRET" @:! t
    let line = "LUA_MASKLINE" @:! t
    let count = "LUA_MASKCOUNT" @:! t
  end
end
