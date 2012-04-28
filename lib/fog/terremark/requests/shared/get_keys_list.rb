module Fog
  module Terremark
    module Shared
      module Real
        include Common

        # Get list of SSH keys for an organization
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
        def get_keys_list(organization_id)
          org_path = @path
          @path="/api/extensions/v1.6/"
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Terremark::Shared::GetKeysList.new,
            :path     => "org/#{organization_id}/keys"
          )
          #Restore original path
          @path = org_path
          response
        end
      
      end
    
    end
  end
end
