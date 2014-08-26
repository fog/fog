module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLoadBalancer.html]
        def create_load_balancer(options={})
          request(options)
        end


        def create_load_balancer(sourceipaddressnetworkid, algorithm, networkid, instanceport, scheme, name, sourceport, options={})
          options.merge!(
            'command' => 'createLoadBalancer', 
            'sourceipaddressnetworkid' => sourceipaddressnetworkid, 
            'algorithm' => algorithm, 
            'networkid' => networkid, 
            'instanceport' => instanceport, 
            'scheme' => scheme, 
            'name' => name, 
            'sourceport' => sourceport  
          )
          request(options)
        end
      end

    end
  end
end

