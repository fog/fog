require 'fog/core/collection'
require 'fog/openstack/models/compute/tenant'

module Fog
  module Compute
    class OpenStack
      class Tenants < Fog::Collection
        model Fog::Compute::OpenStack::Tenant

        def all
          load(service.list_tenants.body['tenants'])
        end

        def usages(start_date = nil, end_date = nil, details = false)
          service.list_usages(start_date, end_date, details).body['tenant_usages']
        end

        def get(id)
          self.find {|tenant| tenant.id == id}
        end
        alias_method :find_by_id, :get

      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
