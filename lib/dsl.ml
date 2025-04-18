open struct
  open LuaStub
  module F = Functions
  module T = Types
  module C = Ctypes
end

(*type 'a as_t = As of Ltype.t * 'a*)

(*module Run (S : sig*)
(*    val state : T.State.t C.ptr*)
(*  end) =*)
(*struct*)
(*  open S*)
(**)
(*  let ( let@ ) (As (tag, x)) f =*)
(*    match tag with*)
(*    | `Nil ->*)
(*      let () = F.pushnil state in*)
(*      f x*)
(*  ;;*)
(*end*)
