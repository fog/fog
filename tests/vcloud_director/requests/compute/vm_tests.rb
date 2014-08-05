Shindo.tests('Compute::VcloudDirector | vm requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Each vDC') do
    @org[:Link].select do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end.each do |link|
      @vdc = @service.get_vdc(link[:href].split('/').last).body
      tests('Each vApp') do
        @vdc[:ResourceEntities][:ResourceEntity].select do |r|
          r[:type] == 'application/vnd.vmware.vcloud.vApp+xml'
        end.each do |vapp|
          vapp_id = vapp[:href].split('/').last
          vapp = @service.get_vapp(vapp_id).body

          tests('Each VM') do

            vapp[:Children][:Vm].each do |vm|
              vm_id = vm[:href].split('/').last

              tests("#get_vapp(#{vm_id}).body").returns(Hash) do
                @service.get_vapp(vm_id).body.class
              end

              tests("#get_vapp(#{vm_id}).body[:name]").returns(String) do
                @service.get_vapp(vm_id).body[:name].class
              end

              tests("#get_vapp(#{vm_id}).body[:href]").returns(vm[:href]) do
                @service.get_vapp(vm_id).body[:href]
              end

              tests("#get_vapp(#{vm_id}).body[:GuestCustomizationSection]").returns(Hash) do
                @service.get_vapp(vm_id).body[:GuestCustomizationSection].class
              end

              tests("#get_vapp(#{vm_id}).body[:GuestCustomizationSection]").data_matches_schema(VcloudDirector::Compute::Schema::GUEST_CUSTOMIZATION_SECTION_TYPE) do
                @service.get_vapp(vm_id).body[:GuestCustomizationSection]
              end

              tests("#get_guest_customization_system_section_vapp(#{vm_id})").returns(Hash) do
                @service.get_guest_customization_system_section_vapp(vm_id).body.class
              end

              tests("#get_guest_customization_system_section_vapp(#{vm_id})").data_matches_schema(VcloudDirector::Compute::Schema::GUEST_CUSTOMIZATION_SECTION_TYPE) do
                @service.get_guest_customization_system_section_vapp(vm_id).body
              end

              tests("#get_vapp(#{vm_id}).body[:NetworkConnectionSection]").returns(Hash) do
                @service.get_vapp(vm_id).body[:NetworkConnectionSection].class
              end

              tests("#get_network_connection_system_section_vapp(#{vm_id})").returns(Hash) do
                @service.get_network_connection_system_section_vapp(vm_id).body.class
              end

              tests("#get_vapp(#{vm_id}).body[:'ovf:OperatingSystemSection']").returns(Hash) do
                @service.get_vapp(vm_id).body[:'ovf:OperatingSystemSection'].class
              end

              tests("#get_operating_system_section(#{vm_id})").returns(Hash) do
                @service.get_operating_system_section(vm_id).body.class
              end

              tests("#get_product_sections_vapp(#{vm_id})").returns(Hash) do
                pending if Fog.mocking?
                @service.get_product_sections_vapp(vm_id).body.class
              end

              tests("#get_vapp(#{vm_id}).body[:RuntimeInfoSection]").data_matches_schema(VcloudDirector::Compute::Schema::RUNTIME_INFO_SECTION_TYPE) do
                @service.get_vapp(vm_id).body[:RuntimeInfoSection]
              end

              tests("#get_runtime_info_section_type(#{vm_id})").data_matches_schema(VcloudDirector::Compute::Schema::RUNTIME_INFO_SECTION_TYPE) do
                @service.get_runtime_info_section_type(vm_id).body
              end

              tests("#get_snapshot_section(#{vm_id})").returns(Hash) do
                @service.get_snapshot_section(vm_id).body.class
              end

              tests("#get_vapp(#{vm_id}).body[:VmCapabilities]").data_matches_schema(VcloudDirector::Compute::Schema::VM_CAPABILITIES_TYPE) do
                @service.get_vapp(vm_id).body[:VmCapabilities]
              end

              tests("#get_vm_capabilities(#{vm_id})").data_matches_schema(VcloudDirector::Compute::Schema::VM_CAPABILITIES_TYPE) do
                @service.get_vm_capabilities(vm_id).body
              end

              tests("#get_vapp(#{vm_id}).body[:'ovf:VirtualHardwareSection']").returns(Hash) do
                @section = @service.get_vapp(vm_id).body[:'ovf:VirtualHardwareSection'].class
              end

              tests("#get_virtual_hardware_section(#{vm_id})").returns(Hash) do
                pending if Fog.mocking?
                @section = @service.get_virtual_hardware_section(vm_id).body.class
              end

              tests("#get_cpu_rasd_item(#{vm_id})").returns(Hash) do
                @service.get_cpu_rasd_item(vm_id).body.class
              end

              tests("#get_disks_rasd_items_list(#{vm_id})").returns(Hash) do
                @service.get_disks_rasd_items_list(vm_id).body.class
              end

              tests("#get_disks_rasd_items_list(#{vm_id}).body[:Item]").returns(Array) do
                @service.get_disks_rasd_items_list(vm_id).body[:Item].class
              end

              tests("#get_media_drives_rasd_items_list(#{vm_id})").returns(Hash) do
                @service.get_media_drives_rasd_items_list(vm_id).body.class
              end

              tests("#get_media_drives_rasd_items_list(#{vm_id}).body[:Item]").returns(Array) do
                @service.get_media_drives_rasd_items_list(vm_id).body[:Item].class
              end

              tests("#get_memory_rasd_item(#{vm_id})").returns(Hash) do
                @service.get_memory_rasd_item(vm_id).body.class
              end

              tests("#get_vapp(#{vm_id}) ovf:VirtualHardwareSection has a Network adapter listed").returns(Hash) do
                @service.get_vapp(vm_id).body[:'ovf:VirtualHardwareSection'][:'ovf:Item'].detect do |rasd_item|
                  rasd_item[:'rasd:ElementName'] =~ /^Network adapter/
                end.class
              end

              tests("#get_network_cards_items_list(#{vm_id})").returns(Hash) do
                @service.get_network_cards_items_list(vm_id).body.class
              end

              tests("#get_serial_ports_items_list(#{vm_id})").returns(Hash) do
                pending if Fog.mocking?
                @service.get_serial_ports_items_list(vm_id).body.class
              end

              tests("#get_vapp_metadata(#{vm_id})").data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
                pending if Fog.mocking?
                @service.get_vapp_metadata(vm_id).body
              end

              tests("#post_acquire_ticket(#{vm_id})").data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
                pending # result depends on power state
                @service.post_acquire_ticket(vm_id).body
              end

            end
          end
        end
      end
    end
  end

  tests('#get_vms_in_lease_from_query') do
    pending if Fog.mocking?
    %w[idrecords records references].each do |format|
      tests(":format => #{format}") do
        tests('#body').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
          @body = @service.get_vms_in_lease_from_query(:format => format).body
        end
        key = (format == 'references') ? 'VMReference' : 'VMRecord'
        tests("#body.key?(:#{key})").returns(true) { @body.key?(key.to_sym) }
      end
    end
  end

  #tests('Retrieve non-existent vApp').raises(Fog::Compute::VcloudDirector::Forbidden) do
  #  pending if Fog.mocking?
  #  @service.get_vapp('00000000-0000-0000-0000-000000000000')
  #end

  #tests('Retrieve owner of non-existent vApp').raises(Fog::Compute::VcloudDirector::Forbidden) do
  #  pending if Fog.mocking?
  #  @service.get_vapp_owner('00000000-0000-0000-0000-000000000000')
  #end

  #tests('Delete non-existent vApp').raises(Fog::Compute::VcloudDirector::Forbidden) do
  #  pending if Fog.mocking?
  #  @service.delete_vapp('00000000-0000-0000-0000-000000000000')
  #end

end
