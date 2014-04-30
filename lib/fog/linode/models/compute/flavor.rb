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
          	2
          when 3
          	4
          when 5
          	6
          when 6
          	8
          when 7
          	12
          when 8
          	16
          when 9
          	20
          when 11
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
