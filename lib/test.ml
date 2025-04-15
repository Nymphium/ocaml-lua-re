open Lua
open Lua.CAPI.Functions
open Alcotest

(* Test 1: 状態管理テスト
   - 状態生成後、初期のスタックトップが 0 であることを検証 *)
let test_state_management () =
  Lua.run
  @@ fun state ->
  let top = gettop state in
  check int "初期スタックトップが 0" 0 top
;;

(* Test 2: do_string とグローバル変数操作テスト
   - Lua スクリプトでグローバル変数を設定し、取り出せることを検証 *)
let test_globals () =
  Lua.run
  @@ fun state ->
  ignore @@ dostring state "x = 42";
  let x = get_global state "x" checknumber in
  check (float 1e-6) "グローバル変数 x の値" 42.0 x
;;

(* Test 3: スタック操作テスト
   - 数値のプッシュ・取得後、スタックが正しく操作されることを検証 *)
let test_stack_operations () =
  Lua.run
  @@ fun state ->
  pushnumber state 3.1415;
  let top = gettop state in
  check int "スタックに 1 個の要素" 1 top;
  let num = tonumber state (-1) in
  check (float 1e-6) "プッシュした数値" 3.1415 num;
  pop state 1;
  check int "要素削除後のスタックトップ" 0 (gettop state)
;;

(* TODO: correctly fail and get error message *)
let test_setpanic () =
  Lua.run
  @@ fun state ->
  let _ =
    Lua.setpanic state
    @@ fun state' ->
    print_endline "Panic!";
    ignore @@ pushstring state' "Panic!";
    1
  in
  checkany state @@ dostring state {|error("test panic")|}
;;

let test_buffer () =
  Lua.run
  @@ fun state ->
  let b = Buffer.create state in
  addstring b "Hello, ";
  addstring b "World!";
  let result = Buffer.tostring state b in
  check string "Buffer の内容" "Hello, World!" result
;;

(* Test 4: 関数呼び出しテスト
   - Lua 側で定義した加算関数 add(a,b) を呼び出し、結果が正しいか検証 *)
let test_function_call () =
  Lua.run
  @@ fun state ->
  ignore @@ dostring state "function add(a, b) return a + b end";
  (* Lua グローバル関数 add を取得 *)
  ignore (getglobal state "add");
  pushnumber state 10.0;
  pushnumber state 20.0;
  (* 2 引数で呼び出し、戻り値を 1 とする *)
  call state 2 1;
  let result = tonumber state (-1) in
  check (float 1e-6) "add(10,20) = 30" 30.0 result;
  pop state 1
;;

(* Test 5: プロテクテッドコール／エラー処理テスト
   - 故意にエラーを発生させ、エラー時のメッセージおよびトレースバックが取得できるか検証 *)
(*let test_protected_call () =*)
(*  let state = create () in*)
(*  let ret = dostring state "error('test error')" in*)
(*  check bool "エラー発生" true (ret <> 0);*)
(*  let errmsg = tolstring state (-1) (Ctypes.from_voidp Ctypes.size_t Ctypes.null) in*)
(*  pop state 1;*)
(*  let tb = traceback state Ctypes.null errmsg 0 in*)
(*  check bool "トレースバックが空でない" true (String.length tb > 0);*)
(*  close state*)

(* Test 6: コルーチン（Lua スレッド）テスト
   - 新たに Lua のスレッドを生成し、独立したスタックでコードが実行できるか検証 *)
let test_coroutine () =
  Lua.run
  @@ fun state ->
  let th = newthread state in
  ignore @@ dostring th "return 100";
  let result = tonumber th (-1) in
  check (float 1e-6) "コルーチンの戻り値" 100.0 result;
  pop th 1
;;

(* Test 7: ユーザデータとメタテーブル操作テスト
   - ユーザデータ生成後、Lua 側でメタテーブルを設定し、それが正しく反映されることを検証 *)
let test_userdata_metatable () =
  Lua.run
  @@ fun state ->
  (* ユーザデータを作成：サイズは 1024 バイト *)
  let _userdata = newuserdata state (Unsigned.Size_t.of_int 1024) in
  ignore @@ dostring state "mt = { __index = function(t, k) return 'value:' .. k end }";
  ignore (getglobal state "mt");
  (* グローバル mt をスタックにプッシュ *)
  let mt_set = setmetatable state (-2) in
  check int "メタテーブル設定" 1 mt_set;
  let mt_ok = getmetatable state (-1) in
  check int "メタテーブル存在" 1 mt_ok;
  pop state 1
;;

let () =
  run
    "Lua5.2 API Test Suite"
    [ "State Management", [ test_case "Test State" `Quick test_state_management ]
    ; ( "Globals"
      , [ (*  (test_case "version" `Quick*)
          (*   @@ fun () -> check string "Lua version" "Lua 5.2" Lib._VERSION)*)
          (*;*)
          (test_case "Hello" `Quick
           @@ fun () ->
           ignore
           @@ Lua.run
           @@ fun state ->
           let i = dostring state {|print(_VERSION)|} in
           assert (i = 0))
        ; test_case "Test Globals" `Quick test_globals
        ] )
    ; "Stack Operations", [ test_case "Test Stack" `Quick test_stack_operations ]
    ; "Buffer", [ test_case "Test Buffer" `Quick test_buffer ]
    ; "Wrapper", [ test_case "Test Wrapper" `Quick test_setpanic ]
    ; "Function Calls", [ test_case "Test Function Call" `Quick test_function_call ]
    ; "Coroutines", [ test_case "Test Coroutine" `Quick test_coroutine ]
    ; ( "Userdata and Metatable"
      , [ test_case "Test Userdata Metatable" `Quick test_userdata_metatable ] )
    ]
;;
