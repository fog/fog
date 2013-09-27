module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a list of organizations accessible to you.
        #
        # The system administrator has access to all organizations.
        #
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Organizations.html
        #   vCloud API Documentation
        def get_organizations
          request({
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => 'org'
          })
        end
      end

      class Mock
        def get_organizations
          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :type=>"application/vnd.vmware.vcloud.orgList+xml",
             :href=>make_href('org/'),
             :xsi_schemaLocation=>xsi_schema_location,
             :Org=>
              {:type=>"application/vnd.vmware.vcloud.org+xml",
               :name=>data[:org][:name],
               :href=>make_href("org/#{data[:org][:uuid]}")}}

          Excon::Response.new(
            :body => body,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :status => 200
          )
        end
      end
    end
  end
end
