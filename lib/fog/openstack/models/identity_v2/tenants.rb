require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v2/tenant'

module Fog
  module Identity
    class OpenStack
      class V2
        class Tenants < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V2::Tenant

          def all(options = {})
            load_response(service.list_tenants(options), 'tenants')
          end

          def find_by_id(id)
            cached_tenant = self.find { |tenant| tenant.id == id }
            return cached_tenant if cached_tenant
            tenant_hash = service.get_tenant(id).body['tenant']
            Fog::Identity::OpenStack::V2::Tenant.new(
                tenant_hash.merge(:service => service))
          end

          def destroy(id)
            tenant = self.find_by_id(id)
            tenant.destroy
          end
        end # class Tenants
      end # class V2
    end # class OpenStack
  end # module Compute
end # module Fog
