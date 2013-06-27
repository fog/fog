module Fog
  module Generators
    module Compute
      module Vcloudng

        class Disks
          def self.generate_xml(items=[])
            disks = self.class.new(items)
            disk.generate
          end
          
          def initialize(items=[])
            @items = items
          end
          
          def modify_hard_disk_size(disk_number, new_size)
            found = false
            @items.each do |item|
              if item['resource_type'] == 17
                if item['element_name'] == "Hard disk #{disk_number}"
                  found = true
                  raise "Hard disk size can't be reduced" if item['capacity'].to_i > new_size.to_i 
                  item['capacity'] = new_size
                end
              end
            end
            raise "Hard disk #{disk_number} not found" unless found
            true
          end
          
          def generate
            output = ""
            output << header
            @items.each do |item|
              output << case item['resource_type']
                        when 6
                          scsi_controller(item)
                        when 17
                          hard_disk_item(item)
                        when 5
                          ide_controller_item(item)
                        end
            end
            output << tail
            output
          end
          
          def header
            '
            <vcloud:RasdItemsList xmlns:vcloud="http://www.vmware.com/vcloud/v1.5" 
              xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" 
              type="application/vnd.vmware.vcloud.rasdItemsList+xml" 
              href="https://devlab.mdsol.com/api/vApp/vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae/virtualHardwareSection/disks"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
              
              xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd">
              <vcloud:Link
                      href="https://devlab.mdsol.com/api/vApp/vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae/virtualHardwareSection/disks"
                      rel="edit"
                      type="application/vnd.vmware.vcloud.rasdItemsList+xml"/>
            '
          end
          
          def tail
            '</vcloud:RasdItemsList>'
          end
          
          def hard_disk_item(opts={})
            "<vcloud:Item>
              <rasd:AddressOnParent>#{opts['address_on_parent']}</rasd:AddressOnParent>
              <rasd:Description>#{opts['description']}</rasd:Description> 
              <rasd:ElementName>#{opts['element_name']}</rasd:ElementName>
              <rasd:HostResource vcloud:capacity=\"#{opts['capacity']}\" vcloud:busSubType=\"#{opts['bus_sub_type']}\" vcloud:busType=\"#{opts['bus_type']}\"></rasd:HostResource>
              <rasd:InstanceID>#{opts['instance_id']}</rasd:InstanceID>
              <rasd:Parent>#{opts['parent']}</rasd:Parent>
              <rasd:ResourceType>17</rasd:ResourceType>
            </vcloud:Item>"
          end
          
          def ide_controller_item(opts={})
            "<vcloud:Item>
               <rasd:Address>#{opts['address']}</rasd:Address>
               <rasd:Description>#{opts['description']}</rasd:Description>
               <rasd:ElementName>#{opts['element_name']}</rasd:ElementName>
               <rasd:InstanceID>#{opts['instance_id']}</rasd:InstanceID>
               <rasd:ResourceType>5</rasd:ResourceType>
            </vcloud:Item>"
          end
          
          def scsi_controller(opts={})
            "<vcloud:Item>
              <rasd:Address>#{opts['address']}</rasd:Address>
              <rasd:Description>#{opts['description']}</rasd:Description>
              <rasd:ElementName>#{opts['element_name']}</rasd:ElementName>
              <rasd:InstanceID>#{opts['instance_id']}</rasd:InstanceID>
              <rasd:ResourceSubType>#{opts['resource_sub_type']}</rasd:ResourceSubType>
              <rasd:ResourceType>6</rasd:ResourceType>
            </vcloud:Item>"
          end
          
        end
      end
    end
  end
end