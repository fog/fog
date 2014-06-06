module Fog
  module Compute
    class Cloudstack

      class Real
        # Release the dedication for cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releaseDedicatedCluster.html]
        def release_dedicated_cluster(clusterid, options={})
          options.merge!(
            'command' => 'releaseDedicatedCluster', 
            'clusterid' => clusterid  
          )
          request(options)
        end
      end

    end
  end
end

