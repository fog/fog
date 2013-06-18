#
#<?xml version="1.0" encoding="UTF-8"?>
#<Org xmlns="http://www.vmware.com/vcloud/v1.5" name="DevOps" id="urn:vcloud:org:c6a4c623-c158-41cf-a87a-dbc1637ad55a" type="application/vnd.vmware.vcloud.org+xml" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#    <Link rel="down" type="application/vnd.vmware.vcloud.vdc+xml" name="DevOps - VDC" href="https://example.com/api/vdc/9a06a16b-12c6-44dc-aee1-06aa52262ea3"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.tasksList+xml" href="https://example.com/api/tasksList/c6a4c623-c158-41cf-a87a-dbc1637ad55a"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.catalog+xml" name="Public VM Templates" href="https://example.com/api/catalog/4ee720e5-173a-41ac-824b-6f4908bac975"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.controlAccess+xml" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalog/4ee720e5-173a-41ac-824b-6f4908bac975/controlAccess/"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.catalog+xml" name="prueba" href="https://example.com/api/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.controlAccess+xml" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33/controlAccess/"/>
#    <Link rel="controlAccess" type="application/vnd.vmware.vcloud.controlAccess+xml" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33/action/controlAccess"/>
#    <Link rel="add" type="application/vnd.vmware.admin.catalog+xml" href="https://example.com/api/admin/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalogs"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.orgNetwork+xml" name="DevOps - Dev Network Connection" href="https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17"/>
#    <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/metadata"/>
#    <Description/>
#    <FullName>DevOps</FullName>
#</Org>
# 
# parsed
# 
#{"OrgList"=>
#  [{"type"=>"application/vnd.vmware.vcloud.org+xml",
#    "name"=>"DevOps",
#    "href"=>
#     "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
#    "id"=>"c6a4c623-c158-41cf-a87a-dbc1637ad55a"}]}
#{"OrgList"=>[{"type"=>"application/vnd.vmware.vcloud.org+xml", "name"=>"DevOps", "href"=>"https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a", "id"=>"c6a4c623-c158-41cf-a87a-dbc1637ad55a"}]}
#>> pp vcloud.get_organization("c6a4c623-c158-41cf-a87a-dbc1637ad55a").body
#{"Links"=>
#  [{"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.vdc+xml",
#    "name"=>"DevOps - VDC",
#    "href"=>
#     "https://example.com/api/vdc/9a06a16b-12c6-44dc-aee1-06aa52262ea3"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.tasksList+xml",
#    "href"=>
#     "https://example.com/api/tasksList/c6a4c623-c158-41cf-a87a-dbc1637ad55a"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.catalog+xml",
#    "name"=>"Public VM Templates",
#    "href"=>
#     "https://example.com/api/catalog/4ee720e5-173a-41ac-824b-6f4908bac975"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.controlAccess+xml",
#    "href"=>
#     "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalog/4ee720e5-173a-41ac-824b-6f4908bac975/controlAccess/"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.catalog+xml",
#    "name"=>"prueba",
#    "href"=>
#     "https://example.com/api/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.controlAccess+xml",
#    "href"=>
#     "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33/controlAccess/"},
#   {"rel"=>"controlAccess",
#    "type"=>"application/vnd.vmware.vcloud.controlAccess+xml",
#    "href"=>
#     "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33/action/controlAccess"},
#   {"rel"=>"add",
#    "type"=>"application/vnd.vmware.admin.catalog+xml",
#    "href"=>
#     "https://example.com/api/admin/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/catalogs"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.orgNetwork+xml",
#    "name"=>"DevOps - Dev Network Connection",
#    "href"=>
#     "https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17"},
#   {"rel"=>"down",
#    "type"=>"application/vnd.vmware.vcloud.metadata+xml",
#    "href"=>
#     "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a/metadata"}],
# "href"=>
#  "https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
# "name"=>"DevOps",
# "Description"=>nil}


module Fog
  module Parsers
    module Compute
      module Vcloudng


        class GetOrganization < VcloudngParser

          def reset
            @response = { 'Links' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Link'
              link = extract_attributes(attributes)
              until attributes.empty?
                if attributes.first.is_a?(Array)
                  attribute = attributes.shift
                  link[attribute.first] = attribute.last
                else
                  link[attributes.shift] = attributes.shift
                end
              end
              @response['Links'] << link
            when 'Org'
              org = extract_attributes(attributes)
              until attributes.empty?
                if attributes.first.is_a?(Array)
                  attribute = attributes.shift
                  org[attribute.first] = attribute.last
                else
                  org[attributes.shift] = attributes.shift
                end
              end
              @response['href'] = org['href']
              @response['name'] = org['name']
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