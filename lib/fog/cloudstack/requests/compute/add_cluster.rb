module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addCluster.html]
        def add_cluster(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addCluster') 
          else
            options.merge!('command' => 'addCluster', 
            'clustertype' => args[0], 
            'hypervisor' => args[1], 
            'clustername' => args[2], 
            'podid' => args[3], 
            'zoneid' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

