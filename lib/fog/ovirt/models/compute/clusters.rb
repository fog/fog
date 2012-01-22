require 'fog/core/collection'
require 'fog/ovirt/models/compute/cluster'
require 'fog/ovirt/models/compute/helpers/collection_helper'

module Fog
  module Compute
    class Ovirt

      class Clusters < Fog::Collection

        include Fog::Compute::Ovirt::Helpers::CollectionHelper
        model Fog::Compute::Ovirt::Cluster

        def all(filters = {})
          attrs = connection.client.clusters(filters).map { |cluster| ovirt_attrs(cluster) }
          load attrs
        end

        def get(id)
          new ovirt_attrs(connection.client.cluster(id))
        end

      end
    end
  end
end
