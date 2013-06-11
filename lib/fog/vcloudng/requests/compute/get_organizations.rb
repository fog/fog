module Fog
  module Vcloudng
    module Compute
      class Real

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
            :headers  => {
              #'Content-Type'  => "application/vnd.vmware.vcloud.orgList+xml"
              'Accept' => 'application/*+xml;version=1.5'
            },
            :method   => 'GET',
            :parser   => Fog::Parsers::Vcloudng::Compute::GetOrganizations.new,
            :override_path => true,
            :path     => '/api/org'
          })
        end

      end


    end
  end
end
