#
# <?xml version="1.0" encoding="UTF-8"?>
# <OrgList xmlns="http://www.vmware.com/vcloud/v1.5" type="application/vnd.vmware.vcloud.orgList+xml" href="https://example.com/api/org/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#     <Org type="application/vnd.vmware.vcloud.org+xml" name="DevOps" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a"/>
# </OrgList>
#
# parsed:
# {"OrgList"=>
#   [{"type"=>"application/vnd.vmware.vcloud.org+xml",
#     "name"=>"DevOps",
#     "href"=>
#      "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
#     "id"=>"c6a4c623-c158-41cf-a87a-dbc1637ad55a"}]}
#    

module Fog
  module Parsers
    module Vcloudng
      module Compute

        class GetOrganizations < VcloudngParser

          def reset
            @response = { 'OrgList' => [] }
          end

          def start_element(name, attributes)
            super
            if name == 'Org'
              organization = extract_attributes(attributes)
              organization['id'] = organization['href'].split('/').last
              @response['OrgList'] << organization
            end
          end

        end
      end
    end
  end
end
