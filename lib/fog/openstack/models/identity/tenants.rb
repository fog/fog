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
          self.find {|tenant| tenant.id == id} ||
            Fog::Identity::OpenStack::Tenant.new(
              connection.get_tenant(id).body['tenant'])
        end

        def destroy(id)
          tenant = self.find_by_id(id)
          tenant.destroy
        end
      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
