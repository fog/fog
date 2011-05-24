module Fog
  module Vcloud
    class Compute

      class Real
        basic_request :get_organization
      end

      class Mock

        def get_organization(organization_uri)
          organization_uri = ensure_unparsed(organization_uri)
          if organization = mock_data.organization_from_href(organization_uri)
            xml = Builder::XmlMarkup.new

            mock_it 200,
              xml.Org(xmlns.merge(:href => organization.href, :name => organization.name)) {

                organization.vdcs.each do |vdc|
                  xml.Link(:rel => "down",
                           :href => vdc.href,
                           :type => "application/vnd.vmware.vcloud.vdc+xml",
                           :name => vdc.name)
                  xml.Link(:rel => "down",
                           :href => vdc.catalog.href,
                           :type => "application/vnd.vmware.vcloud.catalog+xml",
                           :name => vdc.catalog.name)
                  xml.Link(:rel => "down",
                           :href => vdc.task_list.href,
                           :type => "application/vnd.vmware.vcloud.tasksList+xml",
                           :name => vdc.task_list.name)
                end
              },
              {'Content-Type' => "application/vnd.vmware.vcloud.org+xml" }
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end

    end
  end
end
