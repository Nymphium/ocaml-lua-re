module Types (S : Ctypes.TYPE) = struct
  open S

  type 'a typ = 'a S.typ
  type 'a ptr = 'a Ctypes_static.ptr
  type 'a structure = 'a Ctypes.structure
  type 'a static_funptr = 'a S.static_funptr

  open struct
    let ( @:! ) name t = constant name t
    let ( .@:[]<- ) t name typ = field t name typ

    (** just flip original *)
    let typedef' name t = typedef t name
  end

  let version_num = "LUA_VERSION_NUM" @:! int
  let number = float
  let int = int
  let unsigned = uint
  let integer = ptrdiff_t
  let lu_byte = uchar
  let string = const string
  let void = void
  let ptr = ptr
  let size_t = size_t
  let char = char
  let bool = view ~read:(fun int -> int = 0) ~write:(fun b -> if b then 0 else 1) int

  module Code = struct
    type t = int

    let t : t typ = int
    let ok = "LUA_OK" @:! t
    let yield = "LUA_YIELD" @:! t
    let errrun = "LUA_ERRRUN" @:! t
    let errsyntax = "LUA_ERRSYNTAX" @:! t
    let errmem = "LUA_ERRMEM" @:! t
    let errerr = "LUA_ERRERR" @:! t
    let errgcmm = "LUA_ERRGCMM" @:! t
    let errfile = "LUA_ERRFILE" @:! t
  end

  module Ref = struct
    type t = int

    let t : t typ = int
    let nil = "LUA_REFNIL" @:! t
    let noref = "LUA_NOREF" @:! t
  end

  module Ltype = struct
    type t = Unsigned.size_t

    let t : t typ = size_t
    let none = "LUA_TNONE" @:! t
    let nil = "LUA_TNIL" @:! t
    let number = "LUA_TNUMBER" @:! t
    let string = "LUA_TSTRING" @:! t
    let table = "LUA_TTABLE" @:! t
    let function_ = "LUA_TFUNCTION" @:! t
    let lightuserdata = "LUA_TLIGHTUSERDATA" @:! t
    let userdata = "LUA_TUSERDATA" @:! t
    let thread = "LUA_TTHREAD" @:! t
    let boolean = "LUA_TBOOLEAN" @:! t
  end

  module State = struct
    type t = unit ptr

    let t : t typ = typedef' "lua_State" @@ ptr void
  end

  module Buffer = struct
    type t = [ `luaL_Buffer ] structure

    let t : t typ = structure "luaL_Buffer"
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
      (unit ptr -> unit ptr -> Ltype.t -> Unsigned.size_t -> unit ptr) static_funptr

    let t : t typ =
      typedef' "lua_Alloc"
      @@ static_funptr
      @@ ptr void
      @-> ptr void
      @-> Ltype.t
      @-> size_t
      @-> returning
      @@ ptr void
    ;;
  end

  module CFunction = struct
    (* NOT abstract type *)
    type t = (State.t ptr -> int) static_funptr

    let t : t typ =
      typedef' "lua_CFunction" @@ static_funptr @@ ptr State.t @-> returning int
    ;;
  end

  module Reader = struct
    (* NOT abstract type *)
    type t = (State.t ptr -> unit ptr -> Unsigned.size_t ptr -> string) static_funptr

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
    type t =
      (State.t ptr -> unit ptr -> Unsigned.size_t -> unit ptr -> Code.t) static_funptr

    let t : t typ =
      typedef' "lua_Writer"
      @@ static_funptr
      @@ ptr State.t
      @-> (const @@ ptr void)
      @-> size_t
      @-> ptr void
      @-> returning Code.t
    ;;
  end

  module Reg = struct
    type t = [ `luaL_Reg ] structure

    let t : t typ = typedef' "luaL_Reg" @@ structure "luaL_Reg"
    let name = t.@:["name"] <- const string
    let func = t.@:["func"] <- CFunction.t
    let () = seal t
  end

  module Debug = struct
    type t = [ `lua_Debug ] structure

    let t' : t typ = structure "lua_Debug"
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
    let isvararg = t'.@:["isvararg"] <- bool
    let istailcall = t'.@:["istailcall"] <- bool
    let short_src = t'.@:["short_src"] <- string
    let () = seal t'
    let t = typedef t' "lua_Debug"
  end

  module Op = struct
    type t = int

    let t : t typ = int
    let add = "LUA_OPADD" @:! t
    let sub = "LUA_OPSUB" @:! t
    let mul = "LUA_OPMUL" @:! t
    let div = "LUA_OPDIV" @:! t
    let mod_ = "LUA_OPMOD" @:! t
    let pow = "LUA_OPPOW" @:! t

    module Comp = struct
      type nonrec t = t

      let t : t typ = t
      let eq = "LUA_OPEQ" @:! t
      let lt = "LUA_OPLT" @:! t
      let le = "LUA_OPLE" @:! t
    end
  end

  module Gc = struct
    type t = int

    let t : t typ = int
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
    type _t = int

    let _t : _t typ = int
    let call = "LUA_HOOKCALL" @:! _t
    let ret = "LUA_HOOKRET" @:! _t
    let line = "LUA_HOOKLINE" @:! _t
    let count = "LUA_HOOKCOUNT" @:! _t
    let tailcall = "LUA_HOOKTAILCALL" @:! _t

    (* overwrite *)

    (* NOT abstract type *)
    type t = (State.t ptr -> Debug.t ptr -> unit) static_funptr

    let t : t typ =
      typedef' "lua_Hook"
      @@ static_funptr
      @@ ptr State.t
      @-> ptr Debug.t
      @-> returning void
    ;;
  end

  module Mask = struct
    type t = int

    let t : t typ = int
    let call = "LUA_MASKCALL" @:! t
    let ret = "LUA_MASKRET" @:! t
    let line = "LUA_MASKLINE" @:! t
    let count = "LUA_MASKCOUNT" @:! t
  end
end
