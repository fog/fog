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
      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
