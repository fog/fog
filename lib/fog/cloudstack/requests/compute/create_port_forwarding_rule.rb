module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a port forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPortForwardingRule.html]
        def create_port_forwarding_rule(options={})
          request(options)
        end


        def create_port_forwarding_rule(virtualmachineid, protocol, privateport, ipaddressid, publicport, options={})
          options.merge!(
            'command' => 'createPortForwardingRule', 
            'virtualmachineid' => virtualmachineid, 
            'protocol' => protocol, 
            'privateport' => privateport, 
            'ipaddressid' => ipaddressid, 
            'publicport' => publicport  
          )
          request(options)
        end
      end

    end
  end
end

