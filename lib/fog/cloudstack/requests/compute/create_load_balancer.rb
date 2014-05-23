module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLoadBalancer.html]
        def create_load_balancer(options={})
          options.merge!(
            'command' => 'createLoadBalancer',
            'networkid' => options['networkid'], 
            'algorithm' => options['algorithm'], 
            'name' => options['name'], 
            'scheme' => options['scheme'], 
            'sourceport' => options['sourceport'], 
            'instanceport' => options['instanceport'], 
            'sourceipaddressnetworkid' => options['sourceipaddressnetworkid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

