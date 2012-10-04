require 'fog/core/collection'
require 'fog/openstack/models/identity/tenant'

module Fog
  module Identity
    class OpenStack
      class Tenants < Fog::Collection
        model Fog::Identity::OpenStack::Tenant

        def all
          load(connection.list_tenants.body['tenants'])
        end

        def find_by_id(id)
          cached_tenant = self.find {|tenant| tenant.id == id}
          return cached_tenant if cached_tenant
          tenant_hash = connection.get_tenant(id).body['tenant']
          Fog::Identity::OpenStack::Tenant.new(
            tenant_hash.merge(:connection => connection))
        end

        def destroy(id)
          tenant = self.find_by_id(id)
          tenant.destroy
        end
      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
