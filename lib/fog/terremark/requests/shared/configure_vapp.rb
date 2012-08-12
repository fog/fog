module Fog
  module Terremark
    module Shared
      module Real
        include Common
        def configure_vapp(vapp_id, vapp_name, options = {})

        items = ""
        vapp_uri = [@host, @path, "vApp", vapp_id.to_s].join("/") 
        
        if options['vcpus']
          vcpu_item = <<-DATA
<Item xmlns="http://schemas.dmtf.org/ovf/envelope/1"> <InstanceID xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">1</InstanceID><ResourceType xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">3</ResourceType><VirtualQuantity xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">#{options['vcpus']}</VirtualQuantity></Item>
DATA
          items << vcpu_item
        end

        if options['memory']
          memory_item = <<-DATA
<Item xmlns="http://schemas.dmtf.org/ovf/envelope/1"><InstanceID xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">2</InstanceID><ResourceType xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">4</ResourceType>38<VirtualQuantity xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">#{options['memory']}</VirtualQuantity></Item>
DATA
          items << memory_item
        end
        #Default root disk
        virtual_disk_item = <<-DATA
<Item>
<AddressOnParent xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">0</AddressOnParent> <HostResource xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">1048576</HostResource><InstanceID xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">9</InstanceID><ResourceType xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">17</ResourceType><VirtualQuantity xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">1048576</VirtualQuantity></Item>
DATA
        items << virtual_disk_item
        #Additional disks
        if options['virtual_disks']
          for disk in options['virtual_disks']
            actual_size = disk.to_i * 1024 * 1024
            virtual_disk_item = <<-DATA
<Item>
<AddressOnParent xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">-1</AddressOnParent><HostResource xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">#{actual_size}</HostResource><InstanceID xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">9</InstanceID><ResourceType xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">17</ResourceType><VirtualQuantity xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">#{actual_size}</VirtualQuantity></Item>
DATA
            items << virtual_disk_item
          end
        end
          
        data = <<-DATA
<VApp href="#{vapp_uri}" type="application/vnd.vmware.vcloud.vApp+xml" name="#{vapp_name}" status="2" size="10485760" xmlns="http://www.vmware.com/vcloud/v0.8" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<VirtualHardwareSection xmlns="http://schemas.dmtf.org/ovf/envelope/1"><Info>Virtual Hardware</Info>#{items}
</VirtualHardwareSection>
</VApp>
DATA

          request(
            :body => data,
            :expects => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vCloud.vApp+xml' },
            :method => 'PUT',
            :path => "vapp/#{vapp_id}"
          )
        end

      end
    end
  end
end
