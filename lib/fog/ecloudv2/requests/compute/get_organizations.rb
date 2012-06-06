module Fog
  module Compute
    class Ecloudv2

      class Real
        basic_request :get_organizations
      end

      class Mock

        def get_organizations(organization_uri)
          organization_uri = ensure_unparsed(organization_uri)
          if organization = mock_data.organization_collection_from_href(organization_uri)
            xml = Builder::XmlMarkup.new

            mock_it 200,
              xml.Organizations(xmlns.merge(:href => organization.href, :name => organization.name)) {

                organization_collection.items.each do |organization|
                  xml.Organization do
                    xml.Id   organization.object_id
                    xml.Href organization.href
                    xml.Name organization.name
                    xml.Type organization.type
                  end
                end
              },
              {'Content-Type' => "application/vnd.tmrk.cloud.organization; type=collection" }
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end

    end
  end
end
