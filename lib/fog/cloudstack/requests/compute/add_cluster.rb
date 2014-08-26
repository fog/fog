module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a new cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addCluster.html]
        def add_cluster(options={})
          request(options)
        end


        def add_cluster(clustertype, hypervisor, clustername, podid, zoneid, options={})
          options.merge!(
            'command' => 'addCluster', 
            'clustertype' => clustertype, 
            'hypervisor' => hypervisor, 
            'clustername' => clustername, 
            'podid' => podid, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

