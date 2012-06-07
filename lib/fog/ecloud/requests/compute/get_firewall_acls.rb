module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_firewall_acls
      end

      class Mock
        def get_firewall_acls(uri)
        end
      end
    end
  end
end
