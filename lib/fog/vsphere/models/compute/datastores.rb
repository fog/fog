require 'fog/core/collection'
require 'fog/vsphere/models/compute/datastore'

module Fog
  module Compute
    class Vsphere

      class Datastores < Fog::Collection

        model Fog::Compute::Vsphere::Datastore
        attr_accessor :datacenter

        def all(filters = {})
          load connection.list_datastores(filters.merge(:datacenter => datacenter))
        end

        def get(id)
          requires :datacenter
          new connection.get_datastore(id, datacenter)
        end

      end
    end
  end
end
