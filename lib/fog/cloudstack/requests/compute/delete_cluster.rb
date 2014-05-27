module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a cluster.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCluster.html]
        def delete_cluster(options={})
          options.merge!(
            'command' => 'deleteCluster', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

