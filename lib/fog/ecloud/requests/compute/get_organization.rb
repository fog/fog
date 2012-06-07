module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_organization
      end

      class Mock
        def get_organization(organization_uri)
        end
      end
    end
  end
end
