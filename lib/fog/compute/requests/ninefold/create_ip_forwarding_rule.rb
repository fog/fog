module Fog
  module Ninefold
    class Compute
      class Real

        def create_ip_forwarding_rule(options = {})
          request('createIpForwardingRule', options, :expects => [200],
                  :response_prefix => 'createipforwardingruleresponse', :response_type => Hash)
        end

      end

      class Mock

        def create_ip_forwarding_rule(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
