require 'fog/core/model'

module Fog
  module Compute
    class OpenStack
      class Network < Fog::Model
        identity  :id
        attribute :name
        attribute :addresses
      end # class Network
    end # class OpenStack
  end # module Compute
end # module Fog
