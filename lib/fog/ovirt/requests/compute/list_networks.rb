module Fog
  module Compute
    class Ovirt
      class Real
        def list_networks(cluster_id)
          client.networks(:cluster_id => cluster_id)
        end
      end
      class Mock
        def list_networks(cluster_id)
          []
        end
      end
    end
  end
end
