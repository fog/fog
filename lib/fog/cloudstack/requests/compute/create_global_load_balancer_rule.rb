module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a global load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createGlobalLoadBalancerRule.html]
        def create_global_load_balancer_rule(options={})
          request(options)
        end


        def create_global_load_balancer_rule(gslbdomainname, gslbservicetype, regionid, name, options={})
          options.merge!(
            'command' => 'createGlobalLoadBalancerRule', 
            'gslbdomainname' => gslbdomainname, 
            'gslbservicetype' => gslbservicetype, 
            'regionid' => regionid, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

