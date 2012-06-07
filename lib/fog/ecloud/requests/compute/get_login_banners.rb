module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_login_banners
      end

      class Mock
        def get_login_banners(uri)
        end
      end
    end
  end
end
