module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCluster.html]
        def add_cluster(options={})
          options.merge!(
            'command' => 'addCluster', 
            'podid' => options['podid'], 
            'clustername' => options['clustername'], 
            'zoneid' => options['zoneid'], 
            'clustertype' => options['clustertype'], 
            'hypervisor' => options['hypervisor']  
          )
          request(options)
        end
      end

    end
  end
end

