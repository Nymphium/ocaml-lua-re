open struct
  open Stub
  module F = Functions
  module T = Types
  module C = Ctypes
end

let create ?size state =
  let b = C.allocate T.Buffer.t @@ C.make T.Buffer.t in
  let () =
    match size with
    | Some size -> F.buffinitsize state b size
    | None -> F.buffinit state b
  in
  b
;;

let tostring state b =
  F.pushresult b;
  F.tostring state (-1)
;;
