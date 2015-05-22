require 'fog/core/collection'
require 'fog/openstack/models/compute/service'

module Fog
  module Compute
    class OpenStack
      class Services < Fog::Collection
        model Fog::Compute::OpenStack::Service

        def all(parameters=nil)
          load(service.list_services(parameters).body['services'])
        end

        def details(parameters=nil)
          load(service.list_services(parameters).body['services'])
        end
      end
    end
  end
end
