require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class Vlan < Fog::Model
        identity :id
        attribute :name
        attribute :location
      end
    end
  end
end
