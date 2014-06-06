module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicate an existing cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateCluster.html]
        def dedicate_cluster(clusterid, domainid, options={})
          options.merge!(
            'command' => 'dedicateCluster', 
            'clusterid' => clusterid, 
            'domainid' => domainid  
          )
          request(options)
        end
      end

    end
  end
end

