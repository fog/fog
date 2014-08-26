module Fog
  module Compute
    class Cloudstack

      class Real
        # List the ip forwarding rules
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listIpForwardingRules.html]
        def list_ip_forwarding_rules(options={})
          options.merge!(
            'command' => 'listIpForwardingRules'  
          )
          request(options)
        end
      end

    end
  end
end

