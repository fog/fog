module Fog
  module Vcloudng
    module Compute
      class Real

        require 'fog/vcloudng/parsers/compute/get_vdc'
        
        # Get details of a vdc
        #
        # ==== Parameters
        # * vdc_id<~Integer> - Id of vdc to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:

        # FIXME

        #     * 'CatalogItems'<~Array>
        #       * 'href'<~String> - linke to item
        #       * 'name'<~String> - name of item
        #       * 'type'<~String> - type of item
        #     * 'description'<~String> - Description of catalog
        #     * 'name'<~String> - Name of catalog
        #
        # === How to get the catalog_uuid?
        #
        # org_uuid = vcloud.get_organizations.data[:body]["OrgList"].first["href"].split('/').last
        # org = vcloud.get_organization(org_uuid)
        # vdc_id = org.data[:body]["Links"].detect {|l| l["type"] =~ /vcloud.vdc/ }["href"].split('/').last
        #
        def get_vdc(vdc_id)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser   => Fog::Parsers::Vcloudng::Compute::GetVdc.new,
            :path     => "vdc/#{vdc_id}"
          )
        end

      end
      
    end
  end
end