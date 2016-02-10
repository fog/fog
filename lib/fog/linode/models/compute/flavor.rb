require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Flavor < Fog::Model
        identity :id
        attribute :disk
        attribute :name
        attribute :ram
        attribute :transfer
        attribute :price
        attribute :price_hourly
        attribute :cores
        attribute :available

        def bits
          0 # these are determined by images you select not the hardware
        end
      end
    end
  end
end
