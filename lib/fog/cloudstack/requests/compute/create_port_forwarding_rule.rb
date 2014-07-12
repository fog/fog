module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a port forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPortForwardingRule.html]
        def create_port_forwarding_rule(publicport, virtualmachineid, ipaddressid, privateport, protocol, options={})
          options.merge!(
            'command' => 'createPortForwardingRule', 
            'publicport' => publicport, 
            'virtualmachineid' => virtualmachineid, 
            'ipaddressid' => ipaddressid, 
            'privateport' => privateport, 
            'protocol' => protocol  
          )
          request(options)
        end
      end

    end
  end
end

