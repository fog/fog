  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates an existing cluster
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateCluster.html]
          def update_cluster(options={})
            options.merge!(
              'command' => 'updateCluster'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
