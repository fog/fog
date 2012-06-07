module Fog
  module Compute
    class Ecloud

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
