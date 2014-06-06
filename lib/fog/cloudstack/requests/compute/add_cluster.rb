module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCluster.html]
        def add_cluster(podid, clustername, clustertype, hypervisor, zoneid, options={})
          options.merge!(
            'command' => 'addCluster', 
            'podid' => podid, 
            'clustername' => clustername, 
            'clustertype' => clustertype, 
            'hypervisor' => hypervisor, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

