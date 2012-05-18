module Fog
  module Compute
    class Ecloudv2

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
