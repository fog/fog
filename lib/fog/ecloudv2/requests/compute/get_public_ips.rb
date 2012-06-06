module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_public_ips
      end

      class Mock
        def get_public_ips(uri)
        end
      end
    end
  end
end
