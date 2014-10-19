module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicate an existing cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/dedicateCluster.html]
        def dedicate_cluster(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'dedicateCluster') 
          else
            options.merge!('command' => 'dedicateCluster', 
            'clusterid' => args[0], 
            'domainid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

