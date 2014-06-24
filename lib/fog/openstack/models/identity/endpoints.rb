require 'fog/core/collection'
require 'fog/openstack/models/identity/service'

module Fog
  module Identity
    class OpenStack
      class Endpoints < Fog::Collection
        model Fog::Identity::OpenStack::Endpoint

        def all
          load(service.list_endpoints.body['endpoints'])
        end

        def find_by_id(id)
          cached_endpoint = self.find {|endpoint| endpoint.id == id}
          return cached_endpoint if cached_endpoint
          endpoint_hash = service.get_endpoint(id).body['endpoint']
          Fog::Identity::OpenStack::Endpoint.new(
            endpoint_hash.merge(:service => service))
        end

        def destroy(id)
          endpoint = self.find_by_id(id)
          endpoint.destroy
        end
      end # class Endpoints
    end # class OpenStack
  end # module Compute
end # module Fog
