require 'spec'
require 'spec/mocks'

Shindo.tests("Vcloud::Compute | disk_requests", ['vcloud']) do

  @xmlns = {
    "xmlns" => "http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData",
    "xmlns:vcloud" => "http://www.vmware.com/vcloud/v1"
  }

  def disk_hash
    [{:"rasd:AddressOnParent"=>"0",
       :"rasd:Description"=>"Hard disk",
       :"rasd:ElementName"=>"Hard disk 1",
       :"rasd:HostResource"=>
       {:vcloud_capacity=>"8192",
         :vcloud_busType=>"6",
         :vcloud_busSubType=>"lsilogic"},
       :"rasd:InstanceID"=>"2000",
       :"rasd:Parent"=>"2",
       :"rasd:ResourceType"=>"17"}]
  end

  def nokogiri_load
    Nokogiri::XML(MockDiskResponse.new.body)
  end

  class MockDiskResponse
    def body
      <<EOF
<RasdItemsList xmlns="http://www.vmware.com/vcloud/v1" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" type="application/vnd.vmware.vcloud.rasdItemsList+xml" href="https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-329805878/virtualHardwareSection/disks" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd http://www.vmware.com/vcloud/v1 http://vcd01.esx.dev.int.realestate.com.au/api/v1.0/schema/master.xsd">
    <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItemsList+xml" href="https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-329805878/virtualHardwareSection/disks"/>
    <Item>
        <rasd:Address>0</rasd:Address>
        <rasd:Description>SCSI Controller</rasd:Description>
        <rasd:ElementName>SCSI Controller 0</rasd:ElementName>
        <rasd:InstanceID>2</rasd:InstanceID>
        <rasd:ResourceSubType>lsilogic</rasd:ResourceSubType>
        <rasd:ResourceType>6</rasd:ResourceType>
    </Item>
    <Item>
        <rasd:AddressOnParent>0</rasd:AddressOnParent>
        <rasd:Description>Hard disk</rasd:Description>
        <rasd:ElementName>Hard disk 1</rasd:ElementName>
        <rasd:HostResource xmlns:vcloud="http://www.vmware.com/vcloud/v1" vcloud:capacity="8192" vcloud:busType="6" vcloud:busSubType="lsilogic"></rasd:HostResource>
        <rasd:InstanceID>2000</rasd:InstanceID>
        <rasd:Parent>2</rasd:Parent>
        <rasd:ResourceType>17</rasd:ResourceType>
    </Item>
    <Item>
        <rasd:Address>0</rasd:Address>
        <rasd:Description>IDE Controller</rasd:Description>
        <rasd:ElementName>IDE Controller 0</rasd:ElementName>
        <rasd:InstanceID>3</rasd:InstanceID>
        <rasd:ResourceType>5</rasd:ResourceType>
    </Item>
</RasdItemsList>
EOF
    end
  end

  unless Fog.mocking?
    Vcloud[:compute].stub!(:request).and_return(MockDiskResponse.new)
  end

  tests("Call to generate config returns string").returns(true) do
    pending if Fog.mocking?
    Vcloud[:compute].generate_configure_vm_disks_request('http://blah', disk_hash).kind_of? String
  end

  tests("Call to generate config with no changes returns input data").returns(true) do
    pending if Fog.mocking?
    Nokogiri::XML(Vcloud[:compute].generate_configure_vm_disks_request('http://blah', disk_hash)).to_s ==
      Nokogiri::XML(MockDiskResponse.new.body).to_s
  end

  tests("Call to generate config with no disks removes disk").returns(true) do
    pending if Fog.mocking?
    xml = Vcloud[:compute].generate_configure_vm_disks_request('http://blah', [])
    ng = Nokogiri::XML(xml)
    # Should have 2 controllers, but no disks.
    ng.xpath("//xmlns:ResourceType", @xmlns).size == 2 &&
    ng.xpath("//xmlns:ResourceType[ .='17']", @xmlns).size == 0
  end

  tests("Call to generate config adding a disk").returns(['4096', true, true]) do
    pending if Fog.mocking?
    disks = disk_hash
    disks << {
      :"rasd:AddressOnParent"=>"1",
      :"rasd:Description"=>"Hard disk",
      :"rasd:ElementName"=>"Hard disk 2",
      :"rasd:HostResource"=>
      {:vcloud_capacity=>"4096",
        :vcloud_busType=>"6",
        :vcloud_busSubType=>"lsilogic"},
      :"rasd:InstanceID"=>"2000",
      :"rasd:Parent"=>"2",
      :"rasd:ResourceType"=>"17"}
    xml = Vcloud[:compute].generate_configure_vm_disks_request('http://blah', disks)
    ng = Nokogiri::XML(xml)
    [
     # should be 4096mb
     ng.at("//xmlns:ResourceType[ .='17']/../xmlns:AddressOnParent[.='-1']/../xmlns:HostResource", @xmlns)["capacity"],
     # Should have 2 controllers, and 2 disks
     ng.xpath("//xmlns:ResourceType", @xmlns).size == 4,
     ng.xpath("//xmlns:ResourceType[ .='17']", @xmlns).size == 2
    ]
  end
  
  unless Fog.mocking?
    Vcloud[:compute].unstub!(:request)
  end
end
