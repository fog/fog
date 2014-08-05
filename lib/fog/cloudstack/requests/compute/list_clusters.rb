module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists clusters.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listClusters.html]
        def list_clusters(options={})
          options.merge!(
            'command' => 'listClusters'  
          )
          request(options)
        end
      end

    end
  end
end

