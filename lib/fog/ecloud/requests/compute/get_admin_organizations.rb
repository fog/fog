module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_admin_organizations
      end

      class Mock
        def get_admin_organizations(uri)
        end
      end
    end
  end
end
