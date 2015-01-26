module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ip forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteIpForwardingRule.html]
        def delete_ip_forwarding_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteIpForwardingRule') 
          else
            options.merge!('command' => 'deleteIpForwardingRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

