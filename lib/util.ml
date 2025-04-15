open struct
  open LuaStub
  module F = Functions
  module T = Types
  module C = Ctypes
end

(** Creates a new pointer of [typ]. *)
let s_ptr typ = C.allocate typ @@ C.make typ
