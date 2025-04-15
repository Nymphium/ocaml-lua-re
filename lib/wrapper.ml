open LuaStub

open struct
  module F = Functions
  module T = Types
end

(** Creates {{!LuaStub.Types.State.type-t} [lua_State]} with {{!LuaStub.Functions.open_libs} [luaL_openlibs]}.
    See also: {!run} *)
let create () =
  let state = F.newstate' () in
  let () = F.open_libs state in
  state
;;

(** Creates {{!LuaStub.Types.State.type-t} [lua_State]} by {!create} and automatically closes the state.
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

(** Gets the global variable [name] from the [state] and check the type with [checker].
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

(** Sets panic handler.
    {[
      run
      @@ fun state ->
      let () =
        ignore
        @@ setpanic state
        @@ fun state' ->
        print_endline "Panic!";
        ignore @@ pushstring state' "Panic!"
      in
      ignore @@ call state 0 0 0 (* panic here *)
    ]} *)
let setpanic state f =
  let f' = Coerce.cfunction f in
  let old = F.atpanic state f' in
  old
;;
