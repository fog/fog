module Fog
  module Compute
    class Ninefold
      class Real

        def delete_ip_forwarding_rule(options = {})
          request('deleteIpForwardingRule', options, :expects => [200],
                  :response_prefix => 'deleteipforwardingruleresponse', :response_type => Hash)
        end

      end
    end
  end
end
