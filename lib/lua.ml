let _VERSION = Const.version

module CAPI = LuaStub

open struct
  module T = LuaStub.Types
end

(** {1 Constants} *)

module Const = Const
module Ltype = T.Ltype
module Code = T.Code
module Ref = T.Ref
module Op = T.Op
module Gc = T.Gc
module Hook = T.Hook
module Mask = T.Mask

(** {1 Utilities} *)

include Wrapper

(** {1 Types-specific} *)

(** {2 {!LuaStub.Types.Buffer} utilities} *)

module Buffer = Buffer
