module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_network
      end

      class Mock
        def get_network(uri)
        end
      end
    end
  end
end
