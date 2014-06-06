module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateCluster.html]
        def update_cluster(id, options={})
          options.merge!(
            'command' => 'updateCluster', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

