module Fog
  module Compute
    class Cloudstack

      class Real
        # List the ip forwarding rules
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listIpForwardingRules.html]
        def list_ip_forwarding_rules(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listIpForwardingRules') 
          else
            options.merge!('command' => 'listIpForwardingRules')
          end
          request(options)
        end
      end

    end
  end
end

