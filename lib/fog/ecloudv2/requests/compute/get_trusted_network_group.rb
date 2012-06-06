module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_trusted_network_group
      end

      class Mock
        def get_trusted_network_group(uri)
        end
      end
    end
  end
end
