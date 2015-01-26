module Fog
  module Compute
    class Vsphere
      class SCSIController < Fog::Model
        attribute :shared_bus
        attribute :type
        attribute :unit_number
        attribute :key

        def to_s
          "#{type} ##{key}: shared: #{shared_bus}, unit_number: #{unit_number}"
        end
      end
    end
  end
end
