module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ip forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteIpForwardingRule.html]
        def delete_ip_forwarding_rule(id, options={})
          options.merge!(
            'command' => 'deleteIpForwardingRule', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

