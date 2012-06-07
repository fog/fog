module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_server_configuration_option
      end

      class Mock
        def get_server_configuration_option(uri)
        end
      end
    end
  end
end
