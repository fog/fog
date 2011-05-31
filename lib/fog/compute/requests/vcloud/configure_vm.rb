# -*- coding: utf-8 -*-
hardware_hash = {:xmlns_vcloud=>"http://www.vmware.com/vcloud/v1",
 :vcloud_href=>
  "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/",
 :vcloud_type=>"application/vnd.vmware.vcloud.virtualHardwareSection+xml",
 :"ovf:Info"=>"Virtual hardware requirements",
 :"ovf:System"=>
  {:"vssd:ElementName"=>"Virtual Hardware Family",
   :"vssd:InstanceID"=>"0",
   :"vssd:VirtualSystemIdentifier"=>"centos",
   :"vssd:VirtualSystemType"=>"vmx-07"},
 :"ovf:Item"=>
  [{:"rasd:Address"=>"00:50:56:01:00:db",
    :"rasd:AddressOnParent"=>"0",
    :"rasd:AutomaticAllocation"=>"true",
    :"rasd:Connection"=>"Gandalf_Dev_OrgNW_to_ExtNW_DirectConnect",
    :"rasd:Description"=>"PCNet32 ethernet adapter",
    :"rasd:ElementName"=>"Network adapter 0",
    :"rasd:InstanceID"=>"1",
    :"rasd:ResourceSubType"=>"PCNet32",
    :"rasd:ResourceType"=>"10"},
   {:"rasd:Address"=>"0",
    :"rasd:Description"=>"SCSI Controller",
    :"rasd:ElementName"=>"SCSI Controller 0",
    :"rasd:InstanceID"=>"2",
    :"rasd:ResourceSubType"=>"lsilogic",
    :"rasd:ResourceType"=>"6"},
   {:"rasd:AddressOnParent"=>"0",
    :"rasd:Description"=>"Hard disk",
    :"rasd:ElementName"=>"Hard disk 1",
    :"rasd:HostResource"=>
     {:vcloud_capacity=>"8192",
      :vcloud_busType=>"6",
      :vcloud_busSubType=>"lsilogic"},
    :"rasd:InstanceID"=>"2000",
    :"rasd:Parent"=>"2",
    :"rasd:ResourceType"=>"17"},
   {:"rasd:Address"=>"0",
    :"rasd:Description"=>"IDE Controller",
    :"rasd:ElementName"=>"IDE Controller 0",
    :"rasd:InstanceID"=>"3",
    :"rasd:ResourceType"=>"5"},
   {:"rasd:AddressOnParent"=>"0",
    :"rasd:AutomaticAllocation"=>"false",
    :"rasd:Description"=>"CD/DVD Drive",
    :"rasd:ElementName"=>"CD/DVD Drive 1",
    :"rasd:HostResource"=>"",
    :"rasd:InstanceID"=>"3000",
    :"rasd:Parent"=>"3",
    :"rasd:ResourceType"=>"15"},
   {:"rasd:AddressOnParent"=>"0",
    :"rasd:AutomaticAllocation"=>"false",
    :"rasd:Description"=>"Floppy Drive",
    :"rasd:ElementName"=>"Floppy Drive 1",
    :"rasd:HostResource"=>"",
    :"rasd:InstanceID"=>"8000",
    :"rasd:ResourceType"=>"14"},
   {:vcloud_href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/cpu",
    :vcloud_type=>"application/vnd.vmware.vcloud.rasdItem+xml",
    :"rasd:AllocationUnits"=>"hertz * 10^6",
    :"rasd:Description"=>"Number of Virtual CPUs",
    :"rasd:ElementName"=>"1 virtual CPU(s)",
    :"rasd:InstanceID"=>"4",
    :"rasd:Reservation"=>"0",
    :"rasd:ResourceType"=>"3",
    :"rasd:VirtualQuantity"=>"1",
    :"rasd:Weight"=>"0",
    :Link=>
     {:rel=>"edit",
      :type=>"application/vnd.vmware.vcloud.rasdItem+xml",
      :href=>
       "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/cpu"}},
   {:vcloud_href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/memory",
    :vcloud_type=>"application/vnd.vmware.vcloud.rasdItem+xml",
    :"rasd:AllocationUnits"=>"byte * 2^20",
    :"rasd:Description"=>"Memory Size",
    :"rasd:ElementName"=>"512 MB of memory",
    :"rasd:InstanceID"=>"5",
    :"rasd:Reservation"=>"0",
    :"rasd:ResourceType"=>"4",
    :"rasd:VirtualQuantity"=>"768",
    :"rasd:Weight"=>"0",
    :Link=>
     {:rel=>"edit",
      :type=>"application/vnd.vmware.vcloud.rasdItem+xml",
      :href=>
       "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/memory"}}],
 :Link=>
  [{:rel=>"edit",
    :type=>"application/vnd.vmware.vcloud.virtualHardwareSection+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/"},
   {:rel=>"down",
    :type=>"application/vnd.vmware.vcloud.rasdItem+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/cpu"},
   {:rel=>"edit",
    :type=>"application/vnd.vmware.vcloud.rasdItem+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/cpu"},
   {:rel=>"down",
    :type=>"application/vnd.vmware.vcloud.rasdItem+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/memory"},
   {:rel=>"edit",
    :type=>"application/vnd.vmware.vcloud.rasdItem+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/memory"},
   {:rel=>"down",
    :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/disks"},
   {:rel=>"edit",
    :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/disks"},
   {:rel=>"down",
    :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/media"},
   {:rel=>"down",
    :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/networkCards"},
   {:rel=>"edit",
    :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
    :href=>
     "https://vcd01.esx.dev.int.realestate.com.au/api/v1.0/vApp/vm-624535987/virtualHardwareSection/networkCards"}]}


module Fog
  module Vcloud
    class Compute
      module Shared
        private

        def validate_vm_data(vm_data)
          valid_opts = [:name, :cpus, :memory, :disks]
          unless valid_opts.all? { |opt| vm_data.keys.include?(opt) }
            raise ArgumentError.new("Required vm data missing: #{(valid_opts - vm_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def generate_configure_vm_request(vm_data)
          xmlns = 'http://schemas.dmtf.org/ovf/envelope/1'
          xmlns_vcloud = 'http://www.vmware.com/vcloud/v1'
          xmlns_rasd = 'http://schemas.dmtf.org/wbem/wscim/1/cim‐schema/2/CIM_ResourceAllocationSettingData'
          xmlns_vssd = 'http://schemas.dmtf.org/wbem/wscim/1/cim‐schema/2/CIM_VirtualSystemSettingData'

          builder = Builder::XmlMarkup.new(:target=>STDOUT, :indent=>2) # TODO - remove params
          builder.VirtualHardwareSection(
                                         :"vcloud:href" => vm_data[:"vcloud_href"],
                                         :"vcloud:type" => vm_data[:"vcloud_type"],
                                         :name => vm_data[:name],
                                         :status => 2,
                                         :size => 0,
                                         :xmlns => xmlns,
                                         :"xmlns:vcloud" => xmlns_vcloud,
                                         :"xmlns:rasd" => xmlns_rasd,
                                         :"xmlns:vssd" => xmlns_vssd) {
            #builder.VirtualHardwareSection(:xmlns => 'http://schemas.dmtf.org/ovf/envelope/1') {

            builder.Info(vm_data[:"ovf:Info"])
            if system = vm_data[:"ovf:System"]
              builder.System {
                builder.ElementName(system[:"vssd:ElementName"], :xmlns => xmlns_vssd) if system[:"vssd:ElementName"]
                builder.InstanceID(system[:"vssd:InstanceID"], :xmlns => xmlns_vssd) if system[:"vssd:InstanceID"]
                builder.VirtualSystemIdentifier(system[:"vssd:VirtualSystemIdentifier"], :xmlns => xmlns_vssd) if system[:"vssd:VirtualSystemIdentifier"]
                builder.VirtualSystemType(system[:"vssd:VirtualSystemType"], :xmlns => xmlns_vssd) if system[:"vssd:VirtualSystemType"]
              }
            end

            vm_data[:'ovf:Item'].each do |oi|
              builder.Item {
                builder.Address(oi[:'rasd:Address'], :xmlns => xmlns_rasd) if oi[:'rasd:Address']
                builder.AddressOnParent(oi[:'rasd:AddressOnParent'], :xmlns => xmlns_rasd) if oi[:'rasd:AddressOnParent']
                builder.AutomaticAllocation(oi[:'rasd:AutomaticAllocation'], :xmlns => xmlns_rasd) if oi[:'rasd:AutomaticAllocation']
                builder.Connection(oi[:'rasd:Connection'], :xmlns => xmlns_rasd) if oi[:'rasd:Connection']
                builder.Description(oi[:'rasd:Description'], :xmlns => xmlns_rasd) if oi[:'rasd:Description']
                builder.ElementName(oi[:'rasd:ElementName'], :xmlns => xmlns_rasd) if oi[:'rasd:ElementName']
                builder.InstanceID(oi[:'rasd:InstanceID'], :xmlns => xmlns_rasd) if oi[:'rasd:InstanceID']
                builder.ResourceSubType(oi[:'rasd:ResourceSubType'], :xmlns => xmlns_rasd) if oi[:'rasd:ResourceSubType']
                builder.ResourceType(oi[:'rasd:ResourceType'], :xmlns => xmlns_rasd) if oi[:'rasd:ResourceType']
                if hr = oi[:'rasd:HostResource']
                  attrs = {}
                  attrs[]
                end
              }
            end



             # builder.Item(:xmlns => 'http://schemas.dmtf.org/ovf/envelope/1') {
             # #builder.Item {
             #   builder.InstanceID(1, :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #   builder.ResourceType(3, :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #   builder.VirtualQuantity(vm_data[:cpus], :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             # }
             # builder.Item(:xmlns => 'http://schemas.dmtf.org/ovf/envelope/1') {
             # #builder.Item {
             #   builder.InstanceID(2, :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #   builder.ResourceType(4, :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #   builder.VirtualQuantity(vm_data[:memory], :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             # }
             # vm_data[:disks].each do |disk_data|
             #   #builder.Item(:xmlns => 'http://schemas.dmtf.org/ovf/envelope/1') {
             #   builder.Item {
             #     builder.AddressOnParent(disk_data[:number], :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #     builder.HostResource(disk_data[:resource], :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #     builder.InstanceID(9, :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #     builder.ResourceType(17, :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #     builder.VirtualQuantity(disk_data[:size], :xmlns => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
             #   }
             # end

           }
        end

        def configure_vm(vm_uri, vm_data)
          validate_vm_data(vm_data)

          request(
            :body     => generate_configure_vm_request(vm_uri, vm_data),
            :expects  => 202,
            :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.vm+xml' },
            :method   => 'PUT',
            :uri      => vm_uri,
            :parse    => true
          )
        end

      end
    end
  end
end

if $0 == __FILE__
  require 'builder'
  i = Fog::Vcloud::Compute::Real.new
  puts i.generate_configure_vm_request(hardware_hash)
end
