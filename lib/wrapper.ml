open LuaStub

open struct
  module F = Functions
  module T = Types
end

let popstring : State.t -> string = Util.popstring
let popnumber : State.t -> float = Util.popnumber

(** Wraps C API functions those which returns {{!LuaStub.Types.Code} {e code}} with {{!Lua.Code} [Code]}. *)
let (capi_call_code_as_result :
      State.t -> (State.t -> T.Code.t) -> (unit, [> `Msg of string ]) result)
  =
  Util.capi_call_code_as_result
;;

(** Creates {{!LuaStub.Types.State.type-t} [lua_State]} with {{!LuaStub.Functions.open_libs} [luaL_openlibs]}.
    See also: {!run} *)
let create () : State.t =
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
let get_global (state : State.t) name checker =
  let () = F.getglobal state name in
  checker state (-1)
;;

(** Sets panic handler to the [state]
    {[
      # let open Lua in
        run @@ fun state ->
          let () =
            ignore @@ set_panic_handler state @@ fun state' ->
              print_endline "Panic!";
              ignore @@ pushstring state' "Panic!"
          in
          ignore @@ CAPI.Functions.call state 0 0 0 (* panic here *);;
      - : unit = ()
    ]} *)
let set_panic_handler (state : State.t) (f : State.t -> int) =
  let f' = CFunction.to_bwd f in
  let old = F.atpanic state f' in
  old
;;

(** Wrapper for {{!LuaStub.Functions.pcall} [pcall]}.
    {@ocaml[
      # let open Lua in
      run @@ fun state ->
        CAPI.Functions.getglobal state "setmetatable";
        call_on_stack state 0 0;;
      - : (unit, [> `Msg of string ]) result =
      Error
       (`Msg
          "Lua error: bad argument #1 to 'setmetatable' (table expected, got no value)")
    ]} *)
let call_on_stack (state : State.t) nargs nresults =
  Util.capi_call_code_as_result state (fun state -> F.pcall state nargs nresults 0)
  |> function
  | Error _ ->
    let msg = F.checkstring state (-1) in
    Error (`Msg (Printf.sprintf "Lua error: %s" msg))
  | ok -> ok
;;

(** Wrapper for {{!LuaStub.Functions.loadfile} [loadfile]}. *)
let load_file (state : State.t) filename =
  Util.capi_call_code_as_result state @@ Fun.flip F.loadfile filename
;;

(** Wrapper for  {{!LuaStub.Functions.loadstring} [loadstring]}. *)
let load_string (state : State.t) str =
  Util.capi_call_code_as_result state @@ Fun.flip F.loadstring str
;;
