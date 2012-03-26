require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class InstanceType < Fog::Model
        identity :id
        attribute :detail
        attribute :label
        attribute :price
      end
    end
  end
end
