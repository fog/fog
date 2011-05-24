require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class StackScript < Fog::Model
        attr_accessor :options
        identity :id
        attribute :name
      end
    end
  end
end
