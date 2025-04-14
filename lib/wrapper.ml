open Stub

open struct
  module F = Functions
  module T = Types
end

(** Creates lua_State with `open_libs`. *)
let create () =
  let state = F.newstate' () in
  let () = F.open_libs state in
  state
;;

(** Creates lua_State by `create` and automatically closes the state. *)
let run f =
  let state = create () in
  Fun.protect
    ~finally:(fun () -> F.close state)
    (fun () ->
      let ret = f state in
      ret)
;;

let get_global state name checker =
  let () = F.getglobal state name in
  checker state (-1)
;;
