module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_ip_addresses
      end

      class Mock
        def get_ip_addresses(uri)
        end
      end
    end
  end
end
