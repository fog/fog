require 'fog/openstack/models/model'

module Fog
  module Compute
    class OpenStack
      class AvailabilityZone < Fog::OpenStack::Model
        identity :zoneName

        attribute :hosts
        attribute :zoneState
      end
    end
  end
end
