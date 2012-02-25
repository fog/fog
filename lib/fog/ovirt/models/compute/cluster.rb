require 'fog/compute/models/server'

module Fog
  module Compute
    class Ovirt

      class Cluster < Fog::Model

        identity :id

        attribute :name
        attribute :raw

        def networks
          connection.client.networks(:cluster_id => id)
        end

        def to_s
          name
        end

      end

    end
  end
end
