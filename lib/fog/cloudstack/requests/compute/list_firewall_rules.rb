module Fog
  module Compute
    class Cloudstack
      class Real
        def list_firewall_rules(options={})
          options.merge!(
            'command' => 'listFirewallRules'
          )
          request(options)
        end

      end
    end
  end
end
