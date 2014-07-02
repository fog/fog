module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a global load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createGlobalLoadBalancerRule.html]
        def create_global_load_balancer_rule(gslbservicetype, gslbdomainname, regionid, name, options={})
          options.merge!(
            'command' => 'createGlobalLoadBalancerRule', 
            'gslbservicetype' => gslbservicetype, 
            'gslbdomainname' => gslbdomainname, 
            'regionid' => regionid, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

