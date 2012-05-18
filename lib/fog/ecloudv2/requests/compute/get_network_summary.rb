module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_network_summary
      end

      class Mock
        def get_network_summary(uri)
        end
      end
    end
  end
end
