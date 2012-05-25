Shindo.tests("Fog::Compute[:vsphere] | vm_update_network request", 'vsphere') do

  require 'rbvmomi'
  require 'fog'
  require 'guid'

  compute = Fog::Compute[:vsphere]

  response = nil
  response_linked = nil
  vm_moid = nil
  vm_uuid = nil

  class ConstClass
    DATACENTER = 'DatacenterCF'
    TEMPLATE = "/Datacenters/#{DATACENTER}/vm/testvm" #path of a vm which need update network
    MOB_TYPE = 'VirtualMachine' # type refereed to an effective VirtualMachine management object
    ADAPTER_NAME = 'Network adapter 1' #vNic name
    PORTGROUP_NAME = 'dvPortGroup' #portgroup name either dvportgroup or vss portgroup
  end

  tests("Get vm management object id by path | The return value should") do
    response = compute.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)
    test("be a kind of mob of VirtualMachine") { response.class.to_s == ConstClass::MOB_TYPE}
  end

  tests("Get vm management object by id | The return value should") do
    response = compute.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)
    vm_moid = response._ref.to_s
    response = compute.get_vm_mob_ref_by_moid(vm_moid)
    test("be a kind of mob of VirtualMachine") { response.class.to_s == ConstClass::MOB_TYPE}
    test("equal to input moid or not") { response._ref.to_s == vm_moid}
  end

  tests("Config vNic network | The return value should") do
    response = compute.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)
    vm_uuid = response.config.instanceUuid
    response = compute.vm_update_network(
      'instance_uuid' => vm_uuid,
      'adapter_name' => ConstClass::ADAPTER_NAME,
      'portgroup_name' => ConstClass::PORTGROUP_NAME
    )
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("reconfig network success or not")  { response.fetch('task_state').to_s == 'success'}
  end

end
