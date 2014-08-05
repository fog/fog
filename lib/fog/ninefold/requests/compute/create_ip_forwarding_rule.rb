module Fog
  module Compute
    class Ninefold
      class Real
        def create_ip_forwarding_rule(options = {})
          request('createIpForwardingRule', options, :expects => [200],
                  :response_prefix => 'createipforwardingruleresponse', :response_type => Hash)
        end
      end
    end
  end
end
