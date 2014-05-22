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
            'virtualmachineid' => options['virtualmachineid'], 
            'privateport' => options['privateport'], 
            'protocol' => options['protocol'], 
            'ipaddressid' => options['ipaddressid'], 
            'publicport' => options['publicport'], 
             
          )
          request(options)
        end
      end

    end
  end
end

