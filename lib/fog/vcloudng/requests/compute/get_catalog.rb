module Fog
  module Vcloudng
    module Compute
      class Real
        
        require 'fog/vcloudng/parsers/compute/get_catalog'
        
        # Get details of a catalog
        #
        # ==== Parameters
        # * catalog_uuid<~UUID> - UUID of the catalog to view catalog for, this UUID comes from /org application/vnd.vmware.vcloud.catalog+xml
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'CatalogItems'<~Array>
        #       * 'href'<~String> - linke to item
        #       * 'name'<~String> - name of item
        #       * 'type'<~String> - type of item
        #     * 'description'<~String> - Description of catalog
        #     * 'name'<~String> - Name of catalog
        #
        # === How to get the catalog_uuid?
        # org_uuid = vcloud.get_organizations.data[:body]["OrgList"].first["href"].split('/').last
        # org = vcloud.get_organization(org_uuid)
        #
        # catalog_uuid = org.data[:body]["Links"].detect {|l| l["type"] =~ /vcloud.catalog/ }["href"].split('/').last
        #
        def get_catalog(catalog_uuid)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser   => Fog::Parsers::Vcloudng::Compute::GetCatalog.new,
            :path     => "catalog/#{catalog_uuid}"
          )
        end

      end
    end
  end
end
