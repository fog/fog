#
#<?xml version="1.0" encoding="UTF-8"?>
#<Catalog xmlns="http://www.vmware.com/vcloud/v1.5" name="prueba" id="urn:vcloud:catalog:ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33" type="application/vnd.vmware.vcloud.catalog+xml" href="https://example.com/api/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#    <Link rel="up" type="application/vnd.vmware.vcloud.org+xml" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33/metadata"/>
#    <Link rel="add" type="application/vnd.vmware.vcloud.catalogItem+xml" href="https://example.com/api/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33/catalogItems"/>
#    <Description>this is a description</Description>
#    <CatalogItems>
#        <CatalogItem type="application/vnd.vmware.vcloud.catalogItem+xml" name="sprintdemo" href="https://example.com/api/catalogItem/05211623-f94b-470e-a3ac-825d5752081c"/>
#        <CatalogItem type="application/vnd.vmware.vcloud.catalogItem+xml" name="sinred" href="https://example.com/api/catalogItem/971f5364-304f-499a-a5ff-e89f629fc503"/>
#        <CatalogItem type="application/vnd.vmware.vcloud.catalogItem+xml" name="sprintdemocopy" href="https://example.com/api/catalogItem/c4173ea2-90ca-4d1e-b6a3-7d3a7a3fba86"/>
#    </CatalogItems>
#    <IsPublished>false</IsPublished>
#</Catalog>


module Fog
  module Parsers
    module Vcloudng
      module Compute

        class GetCatalog < VcloudngParser

          def reset
            @response = { 'CatalogItems' => [], 'Links' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'CatalogItem'
              catalog_item = extract_attributes(attributes)
              catalog_item["id"] = catalog_item["href"].split('/').last
              @response['CatalogItems'] << catalog_item
            when 'Catalog'
              catalog = extract_attributes(attributes)
              @response['name'] = catalog['name']
            when "Link"
              link = extract_attributes(attributes)
              @response["Links"] << link
            end
          end

          def end_element(name)
            case name
            when 'Description'
              @response[name] = value
            when 'IsPublished'
              value_boolean = value == 'false' ? false : true
              @response[name] = value_boolean
            end
          end

        end

      end
    end
  end
end
