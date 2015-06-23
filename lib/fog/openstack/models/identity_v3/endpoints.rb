require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/service'

module Fog
  module Identity
    class OpenStack
      class V3
        class Endpoints < Fog::Collection
          model Fog::Identity::OpenStack::V3::Endpoint

          def all(options = {})
            load(service.list_endpoints(options).body['endpoints'])
          end

          alias_method :summary, :all

          def find_by_id(id)
            cached_endpoint = self.find { |endpoint| endpoint.id == id }
            return cached_endpoint if cached_endpoint
            endpoint_hash = service.get_endpoint(id).body['endpoint']
            Fog::Identity::OpenStack::V3::Endpoint.new(
                endpoint_hash.merge(:service => service))
          end
        end
      end
    end
  end
end
