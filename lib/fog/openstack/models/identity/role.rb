require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class Role < Fog::Model
        identity :id
        attribute :name
      end # class Role
    end # class OpenStack
  end # module Identity
end # module Fog
