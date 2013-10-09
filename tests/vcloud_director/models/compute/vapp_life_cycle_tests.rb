require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

VAPP_NAME = "shindo07"
NETWORK_NAME = "DevOps - Dev Network Connection"
NETWORK_MODE = "POOL"
CATALOG_NAME = "Public VM Templates"
CATALOG_ITEM_NAME = "DEVWEB"
TAGS = { :company => "acme", :environment => "testing" }

Shindo.tests("Compute::VcloudDirector | vapp", ['vclouddirector', 'creation']) do
  pending if Fog.mocking?
  pending # FIXME: vCloud environment needs to be set up in advance
  tests("#it creates a vApp from a catalog item").returns(true){ the_catalog_item.instantiate(VAPP_NAME, { :network_id => the_network.id, :network_name => NETWORK_NAME}) }
  vapp = vapps.get_by_name(VAPP_NAME)
  tests("#Finds the just created vApp").returns(VAPP_NAME) { vapp.name }
  tests("#it has one vm").returns(1) { vapp.vms.size}
  tests("Compute::VcloudDirector | vm", ['configuration']) do
    vm = vapp.vms.first
    tests("Compute::VcloudDirector | vm", ['network']) do
      network = vm.network
      network.network = NETWORK_NAME
      network.is_connected = true
      network.ip_address_allocation_mode = NETWORK_MODE
      tests("save network changes").returns(true){ network.save }
      network.reload
      tests("#network").returns(NETWORK_NAME) { network.network }
      tests("#is_connected").returns(true) { network.is_connected }
      tests("#ip_address_allocation_mode").returns(NETWORK_MODE) { network.ip_address_allocation_mode }
    end

    tests("Compute::VcloudDirector | vm", ['customization']) do
      customization = vm.customization
      customization.script = 'this is the user data'
      customization.enabled = true
      tests("save customization changes").returns(true){ customization.save }
      tests("#script").returns('this is the user data') { customization.script }
      tests("#enabled").returns(true) { customization.enabled  }
    end

    tests("Compute::VcloudDirector | vm", ['doble the disk size']) do
      disk = vm.disks.get_by_name('Hard disk 1')
      tests("#disk_size").returns(Fixnum) { disk.capacity.class}
      new_size = disk.capacity * 2
      disk.capacity = new_size
      disk.reload
      tests("#disk_size is now doubled").returns(new_size) { disk.capacity }
    end

    tests("Compute::VcloudDirector | vm", ['add a new disk']) do
      tests("hard disk 2 doesn't exist").returns(nil) { vm.disks.get_by_name('Hard disk 2') }
      tests("#create").returns(true) { vm.disks.create(1024) }
      tests("hard disk 2 exists").returns(1024) { vm.disks.get_by_name('Hard disk 2').capacity }
      tests("delete disk 2").returns(true) { vm.disks.get_by_name('Hard disk 2').destroy }
      tests("hard disk 2 doesn't exist anymore").returns(nil) { vm.disks.get_by_name('Hard disk 2') }
    end

    tests("Compute::VcloudDirector | vm", ['doble the memory size']) do
      tests("#memory").returns(Fixnum) { vm.memory.class}
      new_size = vm.memory * 2
      vm.memory = new_size
      vm.reload
      tests("#memory is now doubled").returns(new_size) { vm.memory }
    end

    tests("Compute::VcloudDirector | vm", ['doble the cpu size']) do
      tests("#cpu").returns(Fixnum) { vm.cpu.class}
      new_size = vm.cpu * 2
      vm.cpu = new_size
      vm.reload
      tests("#memory is now doubled").returns(new_size) { vm.cpu }
    end

    tests("Compute::VcloudDirector | vm", ['tags']) do
      TAGS.each_pair do |k,v|
        tests('create tag').returns(true) {vm.tags.create(k, v)}
      end
      tests('there are two tags').returns(2){ vm.tags.size }
      tests('#get_by_name').returns("acme"){ vm.tags.get_by_name('company').value }
      tests('#get_by_name').returns("testing"){ vm.tags.get_by_name('environment').value }
      tests('delete company').returns(true){ vm.tags.get_by_name('company').destroy }
      tests("company doesn't exists anymore").returns(nil){ vm.tags.get_by_name('company') }
      tests('there is only one tag').returns(1){ vm.tags.size }
    end

    tests("Compute::VcloudDirector | vm", ['power on']) do
      tests('#vm is off').returns("off"){ vm.status }
      tests('#power_on').returns(true){ vm.power_on }
      vm.reload
      tests('#vm is on').returns("on"){ vm.status }
    end

  end
end
