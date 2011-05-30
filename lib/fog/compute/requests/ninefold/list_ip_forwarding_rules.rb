module Fog
  module Ninefold
    class Compute
      class Real

        def list_ip_forwarding_rules(options = {})
          request('listIpForwardingRules', options, :expects => [200],
                  :response_prefix => 'listipforwardingrulesresponse/ipforwardingrule', :response_type => Hash)
        end

      end
    end
  end
end
