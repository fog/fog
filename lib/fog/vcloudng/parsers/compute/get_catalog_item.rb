#
# <?xml version="1.0" encoding="UTF-8"?>
# <CatalogItem xmlns="http://www.vmware.com/vcloud/v1.5" name="DEVRHL" id="urn:vcloud:catalogitem:5437aa3f-e369-40b2-b985-2e63e1bc9f2e" type="application/vnd.vmware.vcloud.catalogItem+xml" href="https://example.com/api/catalogItem/5437aa3f-e369-40b2-b985-2e63e1bc9f2e" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#     <Link rel="up" type="application/vnd.vmware.vcloud.catalog+xml" href="https://example.com/api/catalog/4ee720e5-173a-41ac-824b-6f4908bac975"/>
#     <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/catalogItem/5437aa3f-e369-40b2-b985-2e63e1bc9f2e/metadata"/>
#     <Description>Red Hat Enterprise Linux 6</Description>
#     <Entity type="application/vnd.vmware.vcloud.vAppTemplate+xml" name="DEVRHL" href="https://example.com/api/vAppTemplate/vappTemplate-165f7321-968e-4f60-93ab-ceea2044200f"/>
# </CatalogItem>


module Fog
  module Parsers
    module Compute
      module Vcloudng

        class GetCatalogItem < VcloudngParser

          def reset
            @response = { 'Entity' => {}, 'Links' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Entity'
              entity_item = extract_attributes(attributes)
              entity_item["id"] = entity_item["href"].split('/').last
              @response['vapp_template_id'] = entity_item["id"]
              @response['Entity'] = entity_item
            when 'CatalogItem'
              catalog_item = extract_attributes(attributes)
              @response['name'] = catalog_item['name']
              @response['type'] = catalog_item['type']
              @response['href'] = catalog_item['href']
              @response['id'] = catalog_item['href'].split('/').last
            when "Link"
              link = extract_attributes(attributes)
              @response["Links"] << link
            end
          end
          
          def end_element(name)
            if name == 'Description'
              @response[name] = value
            end
          end


        end

      end
    end
  end
end
