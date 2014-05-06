module Fog
  module Generators
    module Compute
      module VcloudDirector
        class MemoryItem

          def generate_xml id, memory, end_point
            Nokogiri::XML::Builder.new do |xml|
              xml.Item(
                  'xmlns' => "http://www.vmware.com/vcloud/v1.5",
                  'xmlns:rasd' => "http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData",
                  'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                  'xmlns:ns12' => "http://www.vmware.com/vcloud/v1.5",
                  'ns12:href' => "#{end_point}vApp/#{id}/virtualHardwareSection/memory",
                  'ns12:type' => "application/vnd.vmware.vcloud.rasdItem+xml",
                  'xsi:schemaLocation' => "http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd"
              ) {
                xml.send('rasd:AllocationUnits', 'byte * 2^20')
                xml.send('rasd:Description', 'Memory Size')
                xml.send('rasd:ElementName', "#{memory} MB of memory")
                xml.send('rasd:InstanceID', 5)
                xml.send('rasd:Reservation', 0)
                xml.send('rasd:ResourceType', 4)
                xml.send('rasd:VirtualQuantity', memory)
                xml.send('rasd:Weight', 0)
                xml.Link(:rel => "edit", :type => "application/vnd.vmware.vcloud.rasdItem+xml", :href => "#{end_point}vApp/#{id}/virtualHardwareSection/memory")
              }
            end.to_xml
          end
        end
      end
    end
  end
end
