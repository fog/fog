require 'fog/core/collection'
require 'fog/openstack/models/compute/tenant'

module Fog
  module Compute
    class OpenStack
      class Tenants < Fog::Collection
        model Fog::Compute::OpenStack::Tenant

        def all
          load(connection.list_tenants.body['tenants'])
        end
      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
