module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a cluster.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteCluster.html]
        def delete_cluster(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteCluster') 
          else
            options.merge!('command' => 'deleteCluster', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

