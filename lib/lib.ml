open struct
  module Const' = Const
  module Buffer' = Buffer
end

module Stub = Stub
include Stub.Functions
include Wrapper
module Const = Const'
module Buffer = Buffer'
