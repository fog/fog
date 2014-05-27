module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a port forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPortForwardingRule.html]
        def create_port_forwarding_rule(options={})
          options.merge!(
            'command' => 'createPortForwardingRule', 
            'ipaddressid' => options['ipaddressid'], 
            'virtualmachineid' => options['virtualmachineid'], 
            'protocol' => options['protocol'], 
            'publicport' => options['publicport'], 
            'privateport' => options['privateport']  
          )
          request(options)
        end
      end

    end
  end
end

