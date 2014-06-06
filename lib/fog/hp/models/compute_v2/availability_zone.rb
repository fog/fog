require 'fog/core/model'

module Fog
  module Compute
    class HPV2
      class AvailabilityZone < Fog::Model
        identity :name, :aliases => 'zoneName'

        attribute   :zoneState
        attribute   :hosts

        def available?
          zoneState['available']
        end
      end
    end
  end
end
