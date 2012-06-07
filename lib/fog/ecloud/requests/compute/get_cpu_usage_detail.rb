module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_cpu_usage_detail
      end

      class Mock
        def get_cpu_usage_detail(uri)
        end
      end
    end
  end
end
