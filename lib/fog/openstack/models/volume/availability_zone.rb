require 'fog/openstack/models/model'

module Fog
  module Volume
    class OpenStack
      class AvailabilityZone < Fog::OpenStack::Model
        identity :zoneName

        attribute :zoneState
      end
    end
  end
end
