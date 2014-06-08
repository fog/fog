module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VApp.html
        # @since vCloud API version 0.9
        def get_vapp(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}"
          )
          ensure_list! response.body, :Children, :Vm
          response
        end
      end

      class Mock

        def get_vapp(id)

          # Retrieve a vApp or VM.
          #

          case id
          when /^vapp-/
            body = get_mock_vapp_body(id)
          when /^vm-/
            body = get_mock_vm_body(id)
          else
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )

        end

        def get_mock_vm_body(id)
          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :name => vm[:name],
            :href => make_href("vApp/#{id}"),
            :type => "application/application/vnd.vmware.vcloud.vm+xml",
            :status => vm[:status],
            :deployed => vm[:deployed],
            :needsCustomization => vm[:needs_customization],
            :"ovf:VirtualHardwareSection" => get_vm_virtual_hardware_section_body(id, vm),
            :"ovf:OperatingSystemSection" => get_vm_operating_system_section_body(id, vm),
            :NetworkConnectionSection     => get_vm_network_connection_section_body(id, vm),
            :GuestCustomizationSection    => get_vm_guest_customization_section_body(id, vm),
            :RuntimeInfoSection           => get_vm_runtime_info_section_body(id, vm),
            :SnapshotSection              => get_snapshot_section_body(id),
            :DateCreated       => vm[:date_created], # eg "2014-03-16T10:52:31.874Z"
            :VAppScopedLocalId => vm[:parent_vapp].split('-').last, # strip the vapp- prefix
            :"ovfenv:Environment" => get_vm_ovfenv_environment_section_body(id, vm),
            :VmCapabilities => get_vm_capabilities_section_body(id, vm),
            :StorageProfile => get_vm_storage_profile_section_body(id, vm),
          }
          body
        end

        def get_mock_vapp_body(id)

          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :deployed => "true",
            :status => vapp[:status],
            :name => vapp[:name],
            :type => "application/vnd.vmware.vcloud.vApp+xml",
            :href => make_href("vApp/#{id}"),
            :LeaseSettingsSection => get_vapp_lease_settings_section_body(id),
            :"ovf:StartupSection" => get_vapp_ovf_startup_section_body(id, vapp),
            :"ovf:NetworkSection" => get_vapp_ovf_network_section_body(id, vapp),
            :NetworkConfigSection => get_vapp_network_config_section_body(id, vapp),
            :SnapshotSection      => get_snapshot_section_body(id),
            :DateCreated => vapp[:date_created], # eg "2014-03-16T10:52:31.874Z"
            :Owner => get_owner_section_body(id),
            :InMaintenanceMode => "false",
            :Children => {
              :Vm => get_vapp_children_vms_body(id)
            },
          }
          body
        end

        def get_vapp_ovf_startup_section_body(id, vapp)
          {
            :xmlns_ns12 => "http://www.vmware.com/vcloud/v1.5",
            :ns12_href => make_href("vApp/#{id}"),
            :ns12_type => "application/vnd.vmware.vcloud.startupSection+xml",
            :"ovf:Info" => "VApp startup section",
            :"ovf:Item" => {
              :ovf_stopDelay => "0",
              :ovf_stopAction => "powerOff",
              :ovf_startDelay => "0",
              :ovf_startAction => "powerOn",
              :ovf_order => "0",
              :ovf_id => vapp[:name],
            },
          }
        end

        def get_vapp_ovf_network_section_body(id, vapp)
          {}
        end

        def get_vapp_network_config_section_body(id, vapp)
          {
            :type => "application/vnd.vmware.vcloud.networkConfigSection+xml",
            :href => make_href("vApp/#{id}/networkConfigSection/"),
            :ovf_required => "false",
            :"ovf:Info" => "The configuration parameters for logical networks",
            :NetworkConfig => {
              :networkName =>"mock-net-routed-1",
              :Description =>"",
              :Configuration => {
                :IpScopes => {
                  :IpScope => {
                    :IsInherited =>"true",
                    :Gateway =>"10.10.10.1",
                    :Netmask =>"255.255.255.0",
                    :Dns1 =>"8.8.8.8",
                    :Dns2 =>"8.8.4.4",
                    :DnsSuffix => "testing.example.com",
                    :IsEnabled => "true",
                    :IpRanges => {
                      :IpRange => [
                        {:StartAddress=>"10.10.10.20", :EndAddress=>"10.10.10.49"},
                      ]
                    },
                  },
                },
                :ParentNetwork => {
                  :name => "mock-net-routed-1",
                  :id => vapp[:networks][0][:parent_id],
                  :href => make_href("admin/network/#{vapp[:networks][0][:parent_id]}"),
                },
                :FenceMode => "bridged",
                :RetainNetInfoAcrossDeployments => "false",
              },
              :IsDeployed=>"true",
            },
          }
        end

        def get_vapp_children_vms_body(id)
          child_vms = data[:vms].select do |vm_id, vm_details|
            vm_details[:parent_vapp] == id
          end
          child_vms.keys.collect do |vm_id|
            get_mock_vm_body(vm_id)
          end
        end
        def get_vm_ovfenv_environment_section_body(id, vm)
          # TODO: I'm pretty sure this is just repeating info in other
          # sections, and the OVF part of VMs is extremely verbose. It's
          # likely to not be needed in Mock mode
          {}
        end

        def get_vm_storage_profile_section_body(id, vm)
          {
            :type => "application/vnd.vmware.vcloud.vdcStorageProfile+xml",
            :name => "Mock Storage Profile",
            :href => make_href("vdcStorageProfile/12345678-1234-1234-1234-1234500e49a8"),
          }
        end

        def get_vm_capabilities_section_body(id, vm)
          {
            :type => "application/vnd.vmware.vcloud.vmCapabilitiesSection+xml",
            :href => make_href("vApp/#{id}/vmCapabilities/"),
            :MemoryHotAddEnabled => "false",
            :CpuHotAddEnabled => "false",
          }
        end

        def get_vm_network_connection_section_body(id, vm)
          {
            :type => "application/vnd.vmware.vcloud.networkConnectionSection+xml",
            :href => make_href("vApp/#{id}/networkConnectionSection/"),
            :ovf_required => "false",
            :"ovf:Info" => "Specifies the available VM network connections",
            :PrimaryNetworkConnectionIndex => "0",
            :NetworkConnection => {
              :network => vm[:nics][0][:network_name],
              :needsCustomization => "false",
              :NetworkConnectionIndex => "0",
              :IpAddress => vm[:nics][0][:ip_address],
              :IsConnected => "true",
              :MACAddress => vm[:nics][0][:mac_address],
              :IpAddressAllocationMode => "MANUAL"
            }
          }
        end

        def get_vm_runtime_info_section_body(id, vm)
          {
            :xmlns_ns12 => "http://www.vmware.com/vcloud/v1.5",
            :ns12_href => make_href("vApp/#{id}/runtimeInfoSection"),
            :ns12_type => "application/vnd.vmware.vcloud.virtualHardwareSection+xml",
            :"ovf:Info" => "Specifies Runtime info",
            :VMWareTools => {
              :version => "9282",
            }
          }
        end

        def get_vm_guest_customization_section_body(id, vm)
          {
            :type => "application/vnd.vmware.vcloud.guestCustomizationSection+xml",
            :href => make_href("vApp/#{id}/guestCustomizationSection/"),
            :ovf_required => "false",
            :"ovf:Info" => "Specifies Guest OS Customization Settings",
            :Enabled => "true",
            :ChangeSid => "false",
            :VirtualMachineId => id.split('-').last, # strip the 'vm-' prefix
            :JoinDomainEnabled => "false",
            :UseOrgSettings => "false",
            :AdminPasswordEnabled => "false",
            :AdminPasswordAuto => "true",
            :ResetPasswordRequired => "false",
            :CustomizationScript => vm[:customization_script] || "",
            :ComputerName => vm[:computer_name] || vm[:name],
          }
        end

        def get_vm_operating_system_section_body(id, vm)
          {
            :xmlns_ns12=>"http://www.vmware.com/vcloud/v1.5",
            :ovf_id => "94",
            :ns12_href => make_href("vApp/#{id}/operatingSystemSection/"),
            :ns12_type => "application/vnd.vmware.vcloud.operatingSystemSection+xml",
            :vmw_osType => vm[:guest_os_type], # eg "ubuntu64Guest"
            :"ovf:Info"=>"Specifies the operating system installed",
            :"ovf:Description"=> vm[:guest_os_description], # eg "Ubuntu Linux (64-bit)",
          }
        end

        def get_snapshot_section_body(id)
          {
            :type => "application/vnd.vmware.vcloud.snapshotSection+xml",
            :href => make_href("vApp/#{id}/snapshotSection"),
            :ovf_required => "false",
            :"ovf:Info"   => "Snapshot information section"
          }
        end

        def get_vm_virtual_hardware_section_body(id, vm)

          {:xmlns_ns12=>"http://www.vmware.com/vcloud/v1.5",
           :ovf_transport=>"",
           :ns12_href => make_href("vApp/#{id}/virtualHardwareSection/"),
           :ns12_type=>"application/vnd.vmware.vcloud.virtualHardwareSection+xml",
           :"ovf:Info"=>"Virtual hardware requirements",
           :"ovf:System"=>{
             :"vssd:ElementName"=>"Virtual Hardware Family",
             :"vssd:InstanceID"=>"0",
             :"vssd:VirtualSystemIdentifier" => vm[:name],
             :"vssd:VirtualSystemType"=>"vmx-08"
           },

           :"ovf:Item"=>[

             {:"rasd:Address" => vm[:nics][0][:mac_address],
              :"rasd:AddressOnParent" => "0",
              :"rasd:AutomaticAllocation" => "true",
              :"rasd:Connection" => vm[:nics][0][:network_name],
              :"rasd:Description" => "E1000 ethernet adapter",
              :"rasd:ElementName" => "Network adapter 0",
              :"rasd:InstanceID" => "1",
              :"rasd:ResourceSubType" => "E1000",
              :"rasd:ResourceType" => "10"
             },

             {:"rasd:Address"=>"0",
              :"rasd:Description"=>"SCSI Controller",
              :"rasd:ElementName"=>"SCSI Controller 0",
              :"rasd:InstanceID"=>"2",
              :"rasd:ResourceSubType"=>"lsilogic",
              :"rasd:ResourceType"=>"6"
             },

             {:"rasd:AddressOnParent"=>"0",
              :"rasd:Description"=>"Hard disk",
              :"rasd:ElementName"=>"Hard disk 1",
              :"rasd:HostResource"=>{
                :ns12_capacity=>"51200",
                :ns12_busSubType=>"lsilogic",
                :ns12_busType=>"6"
              },
              :"rasd:InstanceID"=>"2000",
              :"rasd:Parent"=>"2",
              :"rasd:ResourceType"=>"17"
             },

             {:"rasd:Address"=>"0",
              :"rasd:Description"=>"IDE Controller",
              :"rasd:ElementName"=>"IDE Controller 0",
              :"rasd:InstanceID"=>"3",
              :"rasd:ResourceType"=>"5"
             },

             {:"rasd:AddressOnParent"=>"1",
              :"rasd:AutomaticAllocation"=>"true",
              :"rasd:Description"=>"CD/DVD Drive",
              :"rasd:ElementName"=>"CD/DVD Drive 1",
              :"rasd:HostResource"=>"",
              :"rasd:InstanceID"=>"3000",
              :"rasd:Parent"=>"3",
              :"rasd:ResourceType"=>"15"
             },

             {:"rasd:AddressOnParent"=>"0",
              :"rasd:AutomaticAllocation"=>"false",
              :"rasd:Description"=>"Floppy Drive",
              :"rasd:ElementName"=>"Floppy Drive 1",
              :"rasd:HostResource"=>"",
              :"rasd:InstanceID"=>"8000",
              :"rasd:ResourceType"=>"14"
             },

             {:ns12_href => make_href("vApp/#{id}/virtualHardwareSection/cpu"),
              :ns12_type => "application/vnd.vmware.vcloud.rasdItem+xml",
              :"rasd:AllocationUnits"=>"hertz * 10^6",
              :"rasd:Description"=>"Number of Virtual CPUs",
              :"rasd:ElementName"=>"1 virtual CPU(s)",
              :"rasd:InstanceID"=>"4",
              :"rasd:Reservation"=>"0",
              :"rasd:ResourceType"=>"3",
              :"rasd:VirtualQuantity"=>vm[:cpu_count],
              :"rasd:Weight"=>"0",
             },

             {:ns12_href => make_href("vApp/#{id}/virtualHardwareSection/memory"),
              :ns12_type=>"application/vnd.vmware.vcloud.rasdItem+xml",
              :"rasd:AllocationUnits"=>"byte * 2^20",
              :"rasd:Description"=>"Memory Size",
              :"rasd:ElementName"=>"#{vm[:memory_in_mb]} MB of memory",
              :"rasd:InstanceID"=>"5",
              :"rasd:Reservation"=>"0",
              :"rasd:ResourceType"=>"4",
              :"rasd:VirtualQuantity"=>vm[:memory_in_mb],
              :"rasd:Weight"=>"0",
             },
           ],
          }
        end

      end

    end
  end
end
