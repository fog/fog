require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class StackScript < Fog::Model
        identity :id
        attribute :name
      end
    end
  end
end
