  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes an ip forwarding rule
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteIpForwardingRule.html]
          def delete_ip_forwarding_rule(options={})
            options.merge!(
              'command' => 'deleteIpForwardingRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
