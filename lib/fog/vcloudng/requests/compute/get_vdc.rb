module Fog
  module Compute
    class Vcloudng
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
            :parser   => Fog::Parsers::Compute::Vcloudng::GetVdc.new,
            :path     => "vdc/#{vdc_id}"
          )
        end
        
        def vdc_end_point(vdc_id = nil)
          end_point + ( vdc_id ? "vdc/#{vdc_id}" : "vdc" )
        end

      end
      
    end
  end
end