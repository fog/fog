module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_catalog
        end

        class Mock
          def get_catalog(catalog_uri)
            catalog_uri = ensure_unparsed(catalog_uri)
            xml = nil

            if vdc = vdc_from_uri(catalog_uri)
              builder = Builder::XmlMarkup.new

              xml = builder.Catalog(xmlns.merge(
                                                :type => "application/vnd.vmware.vcloud.catalog+xml",
                                                :href => catalog_uri,
                                                :name => vdc[:catalog][:name]
                                    )) do |xml|
                xml.CatalogItems do |xml|
                  vdc[:catalog][:items].each do |catalog_item|
                    xml.CatalogItem(
                                    :type => "application/vnd.vmware.vcloud.catalogItem+xml",
                                    :href => "#{self.class.base_url}/catalogItem/#{catalog_item[:id]}-#{vdc[:id]}",
                                    :name => catalog_item[:name]
                                    )
                  end
                end
              end
            end

            if xml
              mock_it 200,
                xml, { 'Content-Type' => 'application/vnd.vmware.vcloud.catalog+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
