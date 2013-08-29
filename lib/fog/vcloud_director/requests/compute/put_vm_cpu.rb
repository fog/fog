module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def put_vm_cpu(vm_id, num_cpus)
          data = <<EOF
          <Item xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns12="http://www.vmware.com/vcloud/v1.5" ns12:href="#{endpoint}vApp/#{vm_id}/virtualHardwareSection/cpu" ns12:type="application/vnd.vmware.vcloud.rasdItem+xml" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd">
            <rasd:AllocationUnits>hertz * 10^6</rasd:AllocationUnits>
            <rasd:Description>Number of Virtual CPUs</rasd:Description>
            <rasd:ElementName>#{num_cpus} virtual CPU(s)</rasd:ElementName>
            <rasd:InstanceID>4</rasd:InstanceID>
            <rasd:Reservation>0</rasd:Reservation>
            <rasd:ResourceType>3</rasd:ResourceType>
            <rasd:VirtualQuantity>#{num_cpus}</rasd:VirtualQuantity>
            <rasd:Weight>0</rasd:Weight>
            <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItem+xml" href="#{endpoint}vApp/#{vm_id}/virtualHardwareSection/cpu"/>
          </Item>
EOF
          request(
            :body => data,
            :expects  => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml' },
            :method   => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/cpu"
          )
        end
      end
    end
  end
end
