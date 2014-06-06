module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_admin_organization
      end

      class Mock
        def get_admin_organization(uri)
          organization_id = id_from_uri(uri)
          admin_organization    = self.data[:admin_organizations][organization_id]

          if admin_organization
            body = Fog::Ecloud.slice(admin_organization, :id, :organization_id)

            response(:body => body)
          else response(:status => 404) # ?
          end
        end
      end
    end
  end
end
