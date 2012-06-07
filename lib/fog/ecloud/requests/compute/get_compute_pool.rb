module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_compute_pool
      end

      class Mock
        def get_compute_pool(uri)
        end
      end
    end
  end
end
