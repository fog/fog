# -*- encoding: utf-8 -*-
module Fog
  module Vcloud
    class Compute
      class Real
        def configure_vm_cpus(vm_data)
          edit_uri = vm_data.select {|k,v| k == :Link && v[:rel] == 'edit'}
          edit_uri = edit_uri.kind_of?(Array) ? edit_uri.flatten[1][:href] : edit_uri[:Link][:href]

          body = <<EOF
          <Item xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" xmlns:vcloud="http://www.vmware.com/vcloud/v1.5" vcloud:href="#{edit_uri}" vcloud:type="application/vnd.vmware.vcloud.rasdItem+xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://#{@host}/api/v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd">
            <rasd:AllocationUnits>hertz * 10^6</rasd:AllocationUnits>
            <rasd:Description>Number of Virtual CPUs</rasd:Description>
            <rasd:ElementName>#{vm_data[:'rasd:VirtualQuantity']} virtual CPU(s)</rasd:ElementName>
            <rasd:InstanceID>4</rasd:InstanceID>
            <rasd:Reservation>0</rasd:Reservation>
            <rasd:ResourceType>3</rasd:ResourceType>
            <rasd:VirtualQuantity>#{vm_data[:'rasd:VirtualQuantity']}</rasd:VirtualQuantity>
            <rasd:Weight>0</rasd:Weight>
            <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItem+xml" href="#{edit_uri}"/>
        </Item>
EOF
          request(
            :body     => body,
            :expects  => 202,
            :headers  => { 'Content-Type' => vm_data[:"vcloud_type"] || 'application/vnd.vmware.vcloud.rasdItem+xml' },
            :method   => 'PUT',
            :uri      => "#{edit_uri}",
            :parse    => true
          )
        end
      end
    end
  end
end
