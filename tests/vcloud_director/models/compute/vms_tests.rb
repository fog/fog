require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | vms", ['vclouddirector', 'all']) do
  pending if Fog.mocking?
  vapp = vapps.find {|v| v.vms.size >= 1}

  # we can't run these tests if there is no vapps with a vm in them
  pending unless vapp

  vms = vapp.vms
  vm = vms.first

  tests("Compute::VcloudDirector | vm") do
    tests("#model").returns(Fog::Compute::VcloudDirector::Vm){vm.class}
    tests("#id").returns(String){ vm.id.class }
    tests("#name").returns(String){ vm.name.class }
    tests("#href").returns(String){ vm.href.class }
    tests("#deployed").returns(String){ vm.deployed.class }
    tests("#type").returns("application/vnd.vmware.vcloud.vm+xml"){ vm.type }
    tests("#vapp_id").returns(String){ vm.vapp_id.class }
    tests("#status").returns(String){ vm.status.class }
    tests("#operating_system").returns(String){ vm.operating_system.class }
    tests("#ip_address").returns(String){ vm.ip_address.class }
    tests("#cpu").returns(Fixnum){ vm.cpu.class }
    tests("#memory").returns(Fixnum){ vm.memory.class }
    tests("#hard_disks").returns(Array){ vm.hard_disks.class }
    tests("#network_adapters").returns(Array){ vm.network_adapters.class }
  end

  tests("Compute::VcloudDirector | vm", ['get']) do
    tests("#get_by_name").returns(vm.name) { vms.get_by_name(vm.name).name }
    tests("#get").returns(vm.id) { vms.get(vm.id).id }
  end

  tests("Compute::VcloudDirector | vm | disks") do
    tests("#collection").returns(Fog::Compute::VcloudDirector::Disks){ vm.disks.class }
    tests("#get_by_name").returns(Fog::Compute::VcloudDirector::Disk) { vm.disks.get_by_name("Hard disk 1").class }

    hard_disk = vm.disks.get_by_name("Hard disk 1")
    tests("#id").returns(2000){ hard_disk.id }
    tests("#name").returns("Hard disk 1"){ hard_disk.name }
    tests("#description").returns("Hard disk"){ hard_disk.description }
    tests("#resource_type").returns(17){ hard_disk.resource_type }
    tests("#address_on_parent").returns(0){ hard_disk.address_on_parent }
    tests("#parent").returns(2){ hard_disk.parent }
    tests("#capacity").returns(Fixnum){ hard_disk.capacity.class }
    tests("#bus_sub_type").returns(String){ hard_disk.bus_sub_type.class }
    tests("#bus_type").returns(6){ hard_disk.bus_type }
  end

  tests("Compute::VcloudDirector | vm | customization") do
    customization = vm.customization
    tests("#model").returns(Fog::Compute::VcloudDirector::VmCustomization){customization.class}
    tests("#id").returns(String){ customization.id.class }
    tests("#href").returns(String){ customization.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.guestCustomizationSection+xml"){ customization.type }
    tests("#virtual_machine_id").returns(String){ customization.virtual_machine_id.class }
    tests("#computer_name").returns(String){ customization.computer_name.class }
    tests("#enabled").returns(true){ boolean? customization.enabled }
    tests("#change_sid").returns(true){ boolean? customization.change_sid }
    tests("#join_domain_enabled").returns(true){ boolean? customization.join_domain_enabled }
    tests("#use_org_settings").returns(true){ boolean? customization.use_org_settings }
    tests("#admin_password_enabled").returns(true){ boolean? customization.admin_password_enabled }
    tests("#reset_password_required").returns(true){ boolean? customization.reset_password_required }
  end

  tests("Compute::VcloudDirector | vm | network") do
    network = vm.network
    tests("#model").returns(Fog::Compute::VcloudDirector::VmNetwork){network.class}
    tests("#id").returns(String){ network.id.class }
    tests("#href").returns(String){ network.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.networkConnectionSection+xml"){ network.type }
    tests("#info").returns(String){ network.info.class }
    tests("#primary_network_connection_index").returns(Fixnum){ network.primary_network_connection_index.class }
    tests("#network").returns(String){ network.network.class }
    tests("#network_connection_index").returns(Fixnum){ network.network_connection_index.class }
    tests("#mac_address").returns(String){ network.mac_address.class }
    tests("#ip_address_allocation_mode").returns(String){ network.ip_address_allocation_mode.class }
    tests("#needs_customization").returns(true){ boolean? network.needs_customization }
    tests("#is_connected").returns(true){ boolean? network.is_connected }
  end

  tests("Compute::VcloudDirector | vm | tags") do
    tags = vm.tags
    tests("#collection").returns(Fog::Compute::VcloudDirector::Tags){ tags.class }
  end

  # We should also be able to find this VM via Query API
  #  :name is not unique for VMs though, so let us query by href
  tests("Compute::VcloudDirector | vm", ['find_by_query']) do
    tests('we can retrieve :name without lazy loading').returns(vm.name) do
      query_vm = vms.find_by_query(:filter => "href==#{vm.href}").first
      query_vm.attributes[:name]
    end
    tests('we can retrieve name via model object returned by query').returns(vm.name) do
      query_vm = vms.find_by_query(:filter => "href==#{vm.href}").first
      query_vm.name
    end
  end

end
