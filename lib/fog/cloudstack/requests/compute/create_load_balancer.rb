module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLoadBalancer.html]
        def create_load_balancer(scheme, networkid, instanceport, name, algorithm, sourceipaddressnetworkid, sourceport, options={})
          options.merge!(
            'command' => 'createLoadBalancer', 
            'scheme' => scheme, 
            'networkid' => networkid, 
            'instanceport' => instanceport, 
            'name' => name, 
            'algorithm' => algorithm, 
            'sourceipaddressnetworkid' => sourceipaddressnetworkid, 
            'sourceport' => sourceport  
          )
          request(options)
        end
      end

    end
  end
end

