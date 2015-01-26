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
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :Org<~Array<Hash>]:
        #       * :href<~String> - Contains the URI to the linked entity.
        #       * :name<~String> - Contains the name of the linked entity.
        #       * :type<~String> - Contains the type of the linked entity.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Organizations.html
        # @since vCloud API version 0.9
        def get_organizations
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => 'org'
          )
          ensure_list! response.body, :Org
          response
        end
      end

      class Mock
        def get_organizations
          body =
            {:href=>make_href('org/'),
             :type=>"application/vnd.vmware.vcloud.orgList+xml",
             :Org=>
              [{:href=>make_href("org/#{data[:org][:uuid]}"),
                :name=>data[:org][:name],
                :type=>"application/vnd.vmware.vcloud.org+xml"}]}

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
