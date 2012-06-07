module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_ip_address
      end

      class Mock
        def get_ip_address(uri)
        end
      end
    end
  end
end
