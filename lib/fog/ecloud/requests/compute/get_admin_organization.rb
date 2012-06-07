module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_admin_organization
      end

      class Mock
        def get_admin_organization(uri)
        end
      end
    end
  end
end
