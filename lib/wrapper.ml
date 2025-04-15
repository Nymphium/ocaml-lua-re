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
    {@ocaml[
      # let open Lua in
          run @@ fun state -> ignore @@ CAPI.Functions.dostring state {|print("Hello, from", _VERSION)|};;
      Hello, from	Lua 5.2
      - : unit = ()
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
    {@ocaml[
      # let open Lua in
        run @@ fun state ->
          ignore @@ CAPI.Functions.dostring state "x = 42";
          let x = get_global state "x" checknumber in
          x;;
      - : float = 42.
    ]} *)
let get_global state name checker =
  let () = F.getglobal state name in
  checker state (-1)
;;

(** Sets panic handler.
    {[
      # let open Lua in
        run @@ fun state ->
          let () =
            ignore @@ setpanic state @@ fun state' ->
              print_endline "Panic!";
              ignore @@ pushstring state' "Panic!"
          in
          ignore @@ call state 0 0 0 (* panic here *);;
      - : unit = ()
    ]} *)
let setpanic state f =
  let f' = Coerce.cfunction f in
  let old = F.atpanic state f' in
  old
;;
