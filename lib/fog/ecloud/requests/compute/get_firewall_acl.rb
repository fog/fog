module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_firewall_acl
      end

      class Mock
        def get_firewall_acl(uri)
        end
      end
    end
  end
end
