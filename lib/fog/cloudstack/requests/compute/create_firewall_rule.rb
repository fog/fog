  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a firewall rule for a given ip address
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createFirewallRule.html]
          def create_firewall_rule(options={})
            options.merge!(
              'command' => 'createFirewallRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
