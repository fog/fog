module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated clusters.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDedicatedClusters.html]
        def list_dedicated_clusters(options={})
          options.merge!(
            'command' => 'listDedicatedClusters'  
          )
          request(options)
        end
      end

    end
  end
end

