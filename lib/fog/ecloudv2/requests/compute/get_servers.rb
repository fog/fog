module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_tasks
      end

      class Mock
        def get_tasks(uri)
        end
      end
    end
  end
end
