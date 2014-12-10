require 'fog/core/collection'
require 'fog/rackspace/models/identity/tenant'

module Fog
  module Rackspace
    class Identity
      class Tenants < Fog::Collection
        model Fog::Rackspace::Identity::Tenant

        def all
          load(retrieve_tenants)
        end

        def get(id)
          data = retrieve_tenants.find{ |tenant| tenant['id'] == id }
          data && new(data)
        end

        private

        def retrieve_tenants
          data = service.list_tenants.body['tenants']
        end
      end
    end
  end
end
