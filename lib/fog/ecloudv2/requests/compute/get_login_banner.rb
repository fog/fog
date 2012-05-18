module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_login_banner
      end

      class Mock
        def get_login_banner(uri)
        end
      end
    end
  end
end
