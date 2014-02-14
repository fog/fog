  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds a new cluster
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addCluster.html]
          def add_cluster(options={})
            options.merge!(
              'command' => 'addCluster'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
