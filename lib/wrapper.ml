open LuaStub

open struct
  module F = Functions
  module T = Types
end

(** Creates lua_State with {{!LuaStub.Functions.open_libs} [luaL_openlibs]}.
    See also: {!run} *)
let create () =
  let state = F.newstate' () in
  let () = F.open_libs state in
  state
;;

(** Creates lua_State by {!create} and automatically closes the state.
    {[
      run @@ fun state -> ignore @@ dostring state {|print("Hello, from", _VERSION)|}
    ]} *)
let run f =
  let state = create () in
  Fun.protect
    ~finally:(fun () -> F.close state)
    (fun () ->
      let ret = f state in
      ret)
;;

(** Gets the global variable from the {{!LuaStub.Types.State.type-t} [lua_State]} and check the type with [checker].
    {[
      run
      @@ fun state ->
      ignore @@ dostring state "x = 42";
      let x = get_global state "x" checknumber in
      assert (x = 42.0)
    ]} *)
let get_global state name checker =
  let () = F.getglobal state name in
  checker state (-1)
;;

(** Sets panic handler. *)
let setpanic state f =
  let f' = Coerce.cfunction f in
  let old = F.atpanic state f' in
  old
;;
