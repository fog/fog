module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_memory_usage_detail_summary
      end

      class Mock
        def get_memory_usage_detail_summary(uri)
        end
      end
    end
  end
end
