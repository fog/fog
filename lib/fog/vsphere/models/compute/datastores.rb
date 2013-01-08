require 'fog/core/collection'
require 'fog/vsphere/models/compute/datastore'

module Fog
  module Compute
    class Vsphere

      class Datastores < Fog::Collection

        model Fog::Compute::Vsphere::Datastore
        attr_accessor :datacenter

        def all(filters = {})
          load service.list_datastores(filters.merge(:datacenter => datacenter))
        end

        def get(id)
          requires :datacenter
          new service.get_datastore(id, datacenter)
        end

      end
    end
  end
end
