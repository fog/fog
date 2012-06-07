module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_cpu_usage_detail_summary
      end

      class Mock
        def get_cpu_usage_detail_summary(uri)
        end
      end
    end
  end
end
