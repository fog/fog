module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all port forwarding rules for an IP address.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPortForwardingRules.html]
        def list_port_forwarding_rules(options={})
          options.merge!(
            'command' => 'listPortForwardingRules'  
          )
          request(options)
        end
      end

    end
  end
end

