require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class StackScript < Fog::Model
        attr_accessor :options
        identity :id
        attribute :name
      end
    end
  end
end
