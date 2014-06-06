module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_organization
      end

      class Mock
        def get_organization(uri)
          organization_id = id_from_uri(uri)
          organization    = self.data[:organizations][organization_id]

          body = {
            :xmlns_i => "http://www.w3.org/2001/XMLSchema-instance",
            :href    => "/cloudapi/ecloud/organizations/",
            :type    => "application/vnd.tmrk.cloud.organization; type=collection"
          }.merge(organization)

          response(:body => body)
        end
      end
    end
  end
end
