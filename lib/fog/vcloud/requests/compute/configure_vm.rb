module Fog
  module Vcloud
    class Compute
      module Shared
        private

        def validate_vm_data(vm_data)
          valid_opts = [:name, :cpus, :memory, :disks]
          unless valid_opts.all? { |opt| vm_data.key?(opt) }
            raise ArgumentError.new("Required vm data missing: #{(valid_opts - vm_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def generate_configure_vm_request(vm_data)
          xmlns = 'http://schemas.dmtf.org/ovf/envelope/1'
          xmlns_vcloud = 'http://www.vmware.com/vcloud/v1'
          xmlns_rasd = 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData'
          xmlns_vssd = 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData'

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
