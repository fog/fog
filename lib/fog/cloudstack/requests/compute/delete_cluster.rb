  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a cluster.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteCluster.html]
          def delete_cluster(options={})
            options.merge!(
              'command' => 'deleteCluster'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
