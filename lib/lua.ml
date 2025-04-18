let _VERSION = Const.version

module CAPI = LuaStub

open struct
  module T = LuaStub.Types
end

include Wrapper

(** {1 Types, functions and constants wrapper} *)

module CFunction = CFunction
module Alloc = Alloc
module Reader = Reader
module Writer = Writer
module State = State
module Debug = Debug
module Const = Const
module Ltype = Ltype
module Code = Code
module Ref = Ref
module Op = Op
module Gc = Gc
module Hook = Hook
module Mask = Mask
module Buffer = Buffer
