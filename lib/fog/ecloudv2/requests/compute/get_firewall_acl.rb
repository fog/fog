module Fog
  module Compute
    class Ecloudv2

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
