module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a port forwarding rule.  Only the private port and the virtual machine can be updated.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updatePortForwardingRule.html]
        def update_port_forwarding_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updatePortForwardingRule') 
          else
            options.merge!('command' => 'updatePortForwardingRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

