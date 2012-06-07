module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_compute_pools
      end

      class Mock
        def get_compute_pools(uri)
        end
      end
    end
  end
end
