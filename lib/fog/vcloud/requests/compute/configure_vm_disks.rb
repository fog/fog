# -*- coding: utf-8 -*-

# <RasdItemsList xmlns="http://www.vmware.com/vcloud/v1" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" type="application/vnd.vmware.vcloud.rasdItemsList+xml" href="https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-329805878/virtualHardwareSection/disks" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd http://www.vmware.com/vcloud/v1 http://vcd01.esx.dev.int.realestate.com.au/api/v1.0/schema/master.xsd">
#     <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItemsList+xml" href="https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-329805878/virtualHardwareSection/disks"/>
#     <Item>
#         <rasd:Address>0</rasd:Address>
#         <rasd:Description>SCSI Controller</rasd:Description>
#         <rasd:ElementName>SCSI Controller 0</rasd:ElementName>
#         <rasd:InstanceID>2</rasd:InstanceID>
#         <rasd:ResourceSubType>lsilogic</rasd:ResourceSubType>
#         <rasd:ResourceType>6</rasd:ResourceType>
#     </Item>
#     <Item>
#         <rasd:AddressOnParent>0</rasd:AddressOnParent>
#         <rasd:Description>Hard disk</rasd:Description>
#         <rasd:ElementName>Hard disk 1</rasd:ElementName>
#         <rasd:HostResource xmlns:vcloud="http://www.vmware.com/vcloud/v1" vcloud:capacity="8192" vcloud:busType="6" vcloud:busSubType="lsilogic"></rasd:HostResource>
#         <rasd:InstanceID>2000</rasd:InstanceID>
#         <rasd:Parent>2</rasd:Parent>
#         <rasd:ResourceType>17</rasd:ResourceType>
#     </Item>
#     <Item>
#         <rasd:Address>0</rasd:Address>
#         <rasd:Description>IDE Controller</rasd:Description>
#         <rasd:ElementName>IDE Controller 0</rasd:ElementName>
#         <rasd:InstanceID>3</rasd:InstanceID>
#         <rasd:ResourceType>5</rasd:ResourceType>
#     </Item>
# </RasdItemsList>

module Fog
  module Vcloud
    class Compute
      class Real
        def generate_configure_vm_disks_request(href, disk_data)
          xmlns = {
            "xmlns:rasd" => "http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData",
            "xmlns" => "http://www.vmware.com/vcloud/v1"
          }
          # Get the XML from the API, parse it.
          xml = Nokogiri::XML(request( :uri => href).body)

          #xml.root['name'] = vapp_data[:name]

          #disks
          real_disks = xml.xpath("//rasd:ResourceType[ .='17']/..", xmlns)
          real_disk_numbers = real_disks.map { |disk| disk.at('.//rasd:AddressOnParent', xmlns).content }
          disk_numbers = disk_data.map { |vdisk| vdisk[:"rasd:AddressOnParent"].to_s }

          if disk_data.length < real_disks.length
            #Assume we're removing a disk
            remove_disk_numbers = real_disk_numbers - disk_numbers
            remove_disk_numbers.each do |number|
              if result = xml.at("//rasd:ResourceType[ .='17']/../rasd:AddressOnParent[.='#{number}']/..", xmlns)
                result.remove
              end
            end
          elsif disk_data.length > real_disks.length
            add_disk_numbers = disk_numbers - real_disk_numbers

            add_disk_numbers.each do |number|
              new_disk = real_disks.first.dup
              new_disk.at('.//rasd:AddressOnParent', xmlns).content = number.to_i #-1
              new_disk.at('.//rasd:HostResource', xmlns)["vcloud:capacity"] = disk_data.find { |disk| disk[:'rasd:AddressOnParent'].to_s == number.to_s }[:'rasd:HostResource'][:vcloud_capacity].to_s
              # nokogiri bug? shouldn't need to add this explicitly.
              new_disk.at('.//rasd:HostResource', xmlns)["xmlns:vcloud"] = xmlns['xmlns']
              new_disk.at('.//rasd:InstanceID', xmlns).content = (2000 + number.to_i).to_s
              new_disk.at('.//rasd:ElementName', xmlns).content = "Hard disk #{number.to_i + 1}"
              real_disks.first.parent << new_disk
            end

          end
          xml.to_s
        end

        def configure_vm_disks(vm_href, disk_data)
          disk_href = vm_href + '/virtualHardwareSection/disks'

          body = generate_configure_vm_disks_request(disk_href, disk_data)

          request(
            :body     => body,
            :expects  => 202,
            :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml' },
            :method   => 'PUT',
            :uri      => disk_href,
            :parse    => true
          )
        end
      end
    end
  end
end
