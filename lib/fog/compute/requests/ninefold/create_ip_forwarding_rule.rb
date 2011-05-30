module Fog
  module Ninefold
    class Compute
      class Real

        def create_ip_forwarding_rule(options = {})
          request('createIpForwardingRule', options, :expects => [200],
                  :response_prefix => 'createipforwardingruleresponse', :response_type => Hash)
        end

      end
    end
  end
end
