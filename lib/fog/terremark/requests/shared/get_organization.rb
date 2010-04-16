module Fog
  module Terremark
    module Shared
      module Real

        # Get details of an organization
        #
        # ==== Parameters
        # * organization_id<~Integer> - Id of organization to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'description'<~String> - Description of organization
        #     * 'links'<~Array> - An array of links to entities in the organization
        #       * 'href'<~String> - location of link
        #       * 'name'<~String> - name of link
        #       * 'rel'<~String> - action to perform
        #       * 'type'<~String> - type of link
        #     * 'name'<~String> - Name of organization
        def get_organization(organization_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Terremark::Shared::GetOrganization.new,
            :path     => "org/#{organization_id}"
          )
          response
        end

      end

      module Mock

        def get_organization(organization_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end
      end

    end
  end
end
