module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_task
      end

      class Mock
        def get_task(uri)
        end
      end
    end
  end
end
