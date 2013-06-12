module Fog
  module Vcloudng
    module Compute
      class Real

        require 'fog/vcloudng/parsers/compute/get_catalog_item'
        
        # Get details of a catalog item
        #
        # ==== Parameters
        # * catalog_item_uuid<~Integer> - Id of catalog item to lookup
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
        # org_uuid = vcloud.get_organizations.data[:body]["OrgList"].first["href"].split('/').last # get the first one
        # org = vcloud.get_organization(org_uuid)
        #
        # catalog_uuid = org.data[:body]["Links"].detect {|l| l["type"] =~ /vcloud.catalog/ }["href"].split('/').last
        # catalog = vcloud.get_catalog(catalog_uuid)
        # catalog_item_uuid = catalog.body["CatalogItems"].first["href"].split('/').last # get the first one
        #
        def get_catalog_item(catalog_item_uuid)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser   => Fog::Parsers::Vcloudng::Compute::GetCatalogItem.new,
            :path     => "catalogItem/#{catalog_item_uuid}"
          )
        end

      end
    end
  end
end
