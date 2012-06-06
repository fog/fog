Shindo.tests('Fog::Compute[:vsphere] | vm_reboot request', ['vsphere']) do

  require 'rbvmomi'
  require 'fog'

  class ConstClass
    SOFT = "/Datacenters/datacenter/vm/node_clone_test_local" # path to a vm used for softly reboot
    FORCE = "/Datacenters/datacenter/vm/node_clone_test_remote" # path to a vm used for enforced reboot
  end

  compute = Fog::Compute[:vsphere]
  vm_mob_ref_soft = compute.get_vm_mob_ref_by_path('path' => ConstClass::SOFT)
  powered_on_vm_soft = compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref_soft).fetch('instance_uuid')
  vm_mob_ref_force = compute.get_vm_mob_ref_by_path('path' => ConstClass::SOFT)
  powered_on_vm_force = compute.convert_vm_mob_ref_to_attr_hash(vm_mob_ref_force).fetch('instance_uuid')

  tests('The response should') do
    response = compute.vm_reboot('instance_uuid' => powered_on_vm_soft)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.has_key? 'task_state' }
    test('should have a reboot_type key') { response.has_key? 'reboot_type' }
  end

  # When forcing the shutdown, we expect the result to be
  { true => 'reset_power'}.each do |force, expected|
    tests("When force => #{force}") do
      response = compute.vm_reboot('instance_uuid' => powered_on_vm_force, 'force' => force)
      test("should return reboot_type of #{expected}") { response['reboot_type'] == expected }
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_reboot }
  end

end
