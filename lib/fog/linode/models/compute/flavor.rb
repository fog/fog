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

        def cores
          case id
          when 1
            1
          when 2
          	2
          when 4
          	4
          when 6
          	6
          when 7
          	8
          when 8
          	12
          when 9
          	16
          when 10
          	20
          when 12
          	20
          else
          	0
          end
        end

        def bits
          0 # these are determined by images you select not the hardware
        end
      end
    end
  end
end
