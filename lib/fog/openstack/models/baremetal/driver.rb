require 'fog/openstack/models/model'

module Fog
  module Baremetal
    class OpenStack
      class Driver < Fog::OpenStack::Model
        identity :name

        attribute :name
        attribute :hosts

        def properties
          requires :name
          service.get_driver_properties(self.name).body
        end

        def metadata
          requires :name
          service.get_driver(self.name).headers
        end
      end
    end
  end
end
