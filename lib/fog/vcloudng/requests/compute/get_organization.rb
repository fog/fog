module Fog
  module Compute
    class Vcloudng
      class Real

        
        require 'fog/vcloudng/parsers/compute/get_organization'
        
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
        
          request({
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "org/#{organization_id}"
          })
        end

      end


    end
  end
end
