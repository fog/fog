module Fog
  module Vcloud

    class Real
      def get_organization(organization_uri)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Vcloud::GetOrganization.new,
          :uri      => organization_uri
        )
      end

    end

    class Mock

      def get_organization(organization_uri)
        #
        # Based off of:
        # http://support.theenterprisecloud.com/kb/default.asp?id=540&Lang=1&SID=
        # 
        # vCloud API Guide v0.9 - Page 26
        #
        if org = mock_data[:organizations].detect { |org| URI.parse(org[:info][:href]) == organization_uri }
          xml = Builder::XmlMarkup.new

          mock_it Fog::Parsers::Vcloud::GetOrganization.new, 200,
            xml.Org(xmlns.merge(:href => org[:info][:href], :name => org[:info][:name])) {

              org[:vdcs].each do |vdc|
                xml.Link(:rel => "down",
                         :href => vdc[:href],
                         :type => "application/vnd.vmware.vcloud.vdc+xml",
                         :name => vdc[:name])
                xml.Link(:rel => "down",
                         :href => "#{vdc[:href]}/catalog",
                         :type => "application/vnd.vmware.vcloud.catalog+xml",
                         :name => "#{vdc[:name]} Catalog")
                xml.Link(:rel => "down",
                         :href => "#{vdc[:href]}/tasksList",
                         :type => "application/vnd.vmware.vcloud.tasksList+xml",
                         :name => "#{vdc[:name]} Tasks List")
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

