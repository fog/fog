module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_memory_usage_detail
      end

      class Mock
        def get_memory_usage_detail(uri)
        end
      end
    end
  end
end
