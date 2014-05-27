module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicate an existing cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateCluster.html]
        def dedicate_cluster(options={})
          options.merge!(
            'command' => 'dedicateCluster', 
            'clusterid' => options['clusterid'], 
            'domainid' => options['domainid']  
          )
          request(options)
        end
      end

    end
  end
end

