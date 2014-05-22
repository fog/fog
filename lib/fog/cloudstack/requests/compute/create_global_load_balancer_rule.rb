module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a global load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createGlobalLoadBalancerRule.html]
        def create_global_load_balancer_rule(options={})
          options.merge!(
            'command' => 'createGlobalLoadBalancerRule',
            'name' => options['name'], 
            'gslbservicetype' => options['gslbservicetype'], 
            'gslbdomainname' => options['gslbdomainname'], 
            'regionid' => options['regionid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

