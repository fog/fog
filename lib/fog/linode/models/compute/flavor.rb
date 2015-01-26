require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Flavor < Fog::Model
        identity :id
        attribute :disk
        attribute :name
        attribute :ram
        attribute :price
        attribute :cores

        def bits
          0 # these are determined by images you select not the hardware
        end
      end
    end
  end
end
