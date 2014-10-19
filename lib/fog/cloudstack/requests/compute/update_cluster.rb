module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an existing cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateCluster.html]
        def update_cluster(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateCluster') 
          else
            options.merge!('command' => 'updateCluster', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

