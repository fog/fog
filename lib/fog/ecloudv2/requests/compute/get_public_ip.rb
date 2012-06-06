module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_public_ip
      end

      class Mock
        def get_public_ip(uri)
        end
      end
    end
  end
end
