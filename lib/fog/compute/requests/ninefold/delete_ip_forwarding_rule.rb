module Fog
  module Ninefold
    class Compute
      class Real

        def delete_ip_forwarding_rule(options = {})
          request('deleteIpForwardingRule', options, :expects => [200],
                  :response_prefix => 'deleteipforwardingruleresponse', :response_type => Hash)
        end

      end

      class Mock

        def delete_ip_forwarding_rule(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
