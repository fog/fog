module Fog
  module Compute
    class Ecloud

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
