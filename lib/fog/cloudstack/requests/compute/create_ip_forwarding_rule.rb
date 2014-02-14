  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates an ip forwarding rule
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createIpForwardingRule.html]
          def create_ip_forwarding_rule(options={})
            options.merge!(
              'command' => 'createIpForwardingRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
