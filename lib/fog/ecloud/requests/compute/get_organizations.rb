module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_organizations
      end # Real

      class Mock
        def get_organizations(uri)
          organizations = self.data[:organizations].values.dup
          organizations.each{|org| org.delete(:id)}
          body = {
            :xmlns_i => "http://www.w3.org/2001/XMLSchema-instance",
            :href    => "/cloudapi/ecloud/organizations/",
            :type    => "application/vnd.tmrk.cloud.organization; type=collection"
          }.merge(:Organization => (organizations.size > 1 ? organizations : organizations.first))

          response(:body => body)
        end
      end
    end
  end
end
