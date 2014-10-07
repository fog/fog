module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a port forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deletePortForwardingRule.html]
        def delete_port_forwarding_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deletePortForwardingRule') 
          else
            options.merge!('command' => 'deletePortForwardingRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

