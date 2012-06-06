module Fog
  module Compute
    class Ecloudv2

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
