module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def put_vm_memory(vm_id, memory)
          data = <<EOF
          <Item xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns12="http://www.vmware.com/vcloud/v1.5" ns12:href="#{endpoint}vApp/#{vm_id}/virtualHardwareSection/memory" ns12:type="application/vnd.vmware.vcloud.rasdItem+xml" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd">
            <rasd:AllocationUnits>byte * 2^20</rasd:AllocationUnits>
            <rasd:Description>Memory Size</rasd:Description>
            <rasd:ElementName>#{memory} MB of memory</rasd:ElementName>
            <rasd:InstanceID>5</rasd:InstanceID>
            <rasd:Reservation>0</rasd:Reservation>
            <rasd:ResourceType>4</rasd:ResourceType>
            <rasd:VirtualQuantity>#{memory}</rasd:VirtualQuantity>
            <rasd:Weight>0</rasd:Weight>
            <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItem+xml" href="#{endpoint}vApp/#{vm_id}/virtualHardwareSection/memory"/>
          </Item>
EOF
          request(
            :body => data,
            :expects  => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/memory"
          )
        end
      end
    end
  end
end
