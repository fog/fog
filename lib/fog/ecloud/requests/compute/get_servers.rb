module Fog
  module Compute
    class Ecloud

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
