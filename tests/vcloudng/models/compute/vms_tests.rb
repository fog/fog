require_relative './helper.rb'

VCR.use_cassette(File.basename(__FILE__)) do
  
  Shindo.tests("Compute::Vcloudng | vms", ['all']) do
    pending if Fog.mocking?
    vapp = vapps.detect {|vapp| vapp.vms.size >= 1 }
    
    tests("#There is more than one vm").returns(true){ vapp.vms.size >= 1 }
    
    vms = vapp.vms
    vm = vms.first
        
    tests("Compute::Vcloudng | vm") do
      tests("#id").returns(String){ vm.id.class }
      tests("#name").returns(String){ vm.name.class }
      tests("#href").returns(String){ vm.href.class }
      tests("#type").returns("application/vnd.vmware.vcloud.vm+xml"){ vm.type }
      tests("#vapp_id").returns(String){ vm.vapp_id.class }
      tests("#status").returns(String){ vm.status.class }
      tests("#operating_system").returns(String){ vm.operating_system.class }
      tests("#ip_address").returns(String){ vm.ip_address.class }
      tests("#cpu").returns(Fixnum){ vm.cpu.class }
      tests("#memory").returns(Fixnum){ vm.memory.class }
      tests("#hard_disks").returns(Array){ vm.hard_disks.class }
    end
    
    
    tests("Compute::Vcloudng | vm", ['get']) do
      tests("#get_by_name").returns(vm.name) { vms.get_by_name(vm.name).name }
      tests("#get").returns(vm.id) { vms.get(vm.id).id }
    end
  end
end