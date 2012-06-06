module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_internet_services
      end

      class Mock
        def get_internet_services(uri)
        end
      end
    end
  end
end
