Shindo.tests('Fog::Compute[:vsphere] | vm_power_off request', ['vsphere']) do

  require 'rbvmomi'
  require 'fog'
  compute = Fog::Compute[:vsphere]

  class ConstClass
    SOFT = "/Datacenters/datacenter/vm/node_clone_test_local"
    FORCE = "/Datacenters/datacenter/vm/node_clone_test_remote"
  end

  tests('The response should') do
    vm_mob_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::SOFT)
    powered_on_vm_soft = compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref).fetch('instance_uuid')
    response = compute.vm_power_off('instance_uuid' => powered_on_vm_soft, 'wait'=> true)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.has_key? 'task_state' }
    test('should have a power_off_type key') { response.has_key? 'power_off_type' }
    test('should return power_off_type of #{expected}') { response['power_off_type'] == 'shutdown_guest'}
  end

  # When forcing the shutdown, we expect the result to be
  { true => 'cut_power'}.each do |force, expected|
    vm_mob_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::FORCE)
    powered_on_vm_force = compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref).fetch('instance_uuid')
    tests("When 'force' => #{force}") do
      response = compute.vm_power_off('instance_uuid' => powered_on_vm_force, 'force' => force)
      test('should return power_off_type of #{expected}') { response['power_off_type'] == expected }
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_power_off }
  end

end
