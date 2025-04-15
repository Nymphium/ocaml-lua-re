open LuaStub

open struct
  module T = Types
end

let cfunction f =
  Ctypes.coerce
    (Foreign.funptr @@ Ctypes.(ptr T.State.t @-> returning int))
    T.CFunction.t
    f
;;

let alloc f =
  Ctypes.coerce (Foreign.funptr @@ Ctypes.(ptr T.State.t @-> returning int)) T.Alloc.t f
;;

let reader f =
  Ctypes.coerce (Foreign.funptr @@ Ctypes.(ptr T.State.t @-> returning int)) T.Reader.t f
;;

let writer f =
  Ctypes.coerce (Foreign.funptr @@ Ctypes.(ptr T.State.t @-> returning int)) T.Writer.t f
;;

let hook f =
  Ctypes.coerce (Foreign.funptr @@ Ctypes.(ptr T.State.t @-> returning int)) T.Hook.t f
;;
