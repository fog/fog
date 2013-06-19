module Fog
  module Compute
    class Vcloudng
      class Real

        
        require 'fog/vcloudng/parsers/compute/get_organizations'
        
        # Get list of organizations
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'description'<~String> - Description of organization
        #     * 'links'<~Array> - An array of links to entities in the organization
        #     * 'name'<~String> - Name of organization
        def get_organizations
          request({
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "org"
          })
        end

      end


    end
  end
end
