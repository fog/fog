module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a firewall rule of an IP address.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/createFirewallRule.html]
        def create_firewall_rule(options={})
          options.merge!(
            'command' => 'createFirewallRule'
          )

          request(options)
        end

      end
    end
  end
end

