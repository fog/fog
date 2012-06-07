module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_servers
      end

      class Mock
        def get_servers(uri)
        end
      end
    end
  end
end
