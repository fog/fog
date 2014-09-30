module Fog
  module Compute
    class Cloudstack

      class Real
        # Release the dedication for cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/releaseDedicatedCluster.html]
        def release_dedicated_cluster(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'releaseDedicatedCluster') 
          else
            options.merge!('command' => 'releaseDedicatedCluster', 
            'clusterid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

