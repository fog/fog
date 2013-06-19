module Fog
  module Compute
    class Vcloudng
      class Real


        require 'fog/vcloudng/parsers/compute/get_vapp_template'
        
        # Get details of a vapp template
        #
        # ==== Parameters
        # * vapp_template_id<~Integer> - Id of vapp template to lookup
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
        # ==== How to get the catalog_uuid?
        #
        # org_uuid = vcloud.get_organizations.data[:body]["OrgList"].first["href"].split('/').last # get the first one
        # org = vcloud.get_organization(org_uuid)
        #
        # catalog_uuid = org.data[:body]["Links"].detect {|l| l["type"] =~ /vcloud.catalog/ }["href"].split('/').last
        # catalog = vcloud.get_catalog(catalog_uuid)
        # catalog_item_uuid = catalog.body["CatalogItems"].first["href"].split('/').last # get the first one
        # catalog_item = vcloud.get_catalog_item(catalog_item_uuid)
        # vapp_template_uuid = catalog_item.body["Entity"]["id"]
        # vcloud.get_vapp_template(vapp_template_uuid)
        #
        def get_vapp_template(vapp_template_id)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "vAppTemplate/#{vapp_template_id}"
          )
        end
        
        def vapp_template_end_point(vapp_template_id = nil)
          end_point + ( vapp_template_id ? "vAppTemplate/#{vapp_template_id}" : "vAppTemplate" )
        end

      end
    end
  end
end
