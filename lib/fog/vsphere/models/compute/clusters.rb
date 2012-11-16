require 'fog/core/collection'
require 'fog/vsphere/models/compute/cluster'

module Fog
  module Compute
    class Vsphere

      class Clusters < Fog::Collection

        model Fog::Compute::Vsphere::Cluster
        attr_accessor :datacenter

        def all(filters = {})
          requires :datacenter
          load connection.list_clusters(filters.merge(:datacenter => datacenter))
        end

        def get(id)
          requires :datacenter
          new connection.get_cluster(id, datacenter)
        end

      end
    end
  end
end
