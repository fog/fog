module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_server_configuration_options
      end

      class Mock
        def get_server_configuration_options(uri)
        end
      end
    end
  end
end
