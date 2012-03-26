require 'fog/core/collection'
require 'fog/ovirt/models/compute/cluster'

module Fog
  module Compute
    class Ovirt

      class Clusters < Fog::Collection

        model Fog::Compute::Ovirt::Cluster

        def all(filters = {})
          load connection.list_clusters(filters)
        end

        def get(id)
          new connection.get_cluster(id)
        end

      end
    end
  end
end
