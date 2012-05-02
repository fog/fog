module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_networks
      end

      class Mock
        def get_networks(uri)
        end
      end
    end
  end
end
