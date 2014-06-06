module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a cluster.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCluster.html]
        def delete_cluster(id, options={})
          options.merge!(
            'command' => 'deleteCluster', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

