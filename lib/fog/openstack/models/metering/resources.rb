require 'fog/core/collection'
require 'fog/openstack/models/metering/resource'

module Fog
  module Metering
    class OpenStack

      class Resources < Fog::Collection
        model Fog::Metering::OpenStack::Resource

        def all(detailed=true)
          load(service.list_resources.body)
        end

        def find_by_id(resource_id)
          resource = service.get_resource(resource_id).body
          new(resource)
        rescue Fog::Metering::OpenStack::NotFound
          nil
        end
      end

    end
  end
end
