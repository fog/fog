module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ip forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteIpForwardingRule.html]
        def delete_ip_forwarding_rule(options={})
          options.merge!(
            'command' => 'deleteIpForwardingRule', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

