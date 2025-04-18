open struct
  module T = LuaStub.Types
end

type t = T.Debug.t Ctypes.ptr

let create () : t = Util.s_ptr T.Debug.t
