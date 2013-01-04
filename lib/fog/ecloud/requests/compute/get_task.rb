module Fog
  module Compute
    class Ecloud
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
