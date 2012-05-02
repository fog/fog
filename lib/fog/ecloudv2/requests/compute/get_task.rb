module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_server
      end

      class Mock
        def get_server(uri)
        end
      end
    end
  end
end
