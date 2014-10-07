module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a port forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createPortForwardingRule.html]
        def create_port_forwarding_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createPortForwardingRule') 
          else
            options.merge!('command' => 'createPortForwardingRule', 
            'virtualmachineid' => args[0], 
            'protocol' => args[1], 
            'privateport' => args[2], 
            'ipaddressid' => args[3], 
            'publicport' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

