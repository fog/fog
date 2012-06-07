module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_trusted_network_groups
      end

      class Mock
        def get_trusted_network_groups(uri)
        end
      end
    end
  end
end
