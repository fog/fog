Shindo.tests('Fog::Compute[:vsphere] | vm_config_HA request', ['vsphere']) do


  require 'rbvmomi'
  require 'fog'
  compute = Fog::Compute[:vsphere]

  class ConstClass
    DC_NAME = 'Datacenter2012'# name of test datacenter
    CS_NAME = 'cluster-fog' # name referring to a cluster with HA enabled
    VM_NAME_1 = 'cc-copy' # name referring to a vm which sit in HA cluster to disable HA settings
    VM_NAME_2  = 'cc-copy2' # name referring to a vm which sit in a non-HA cluster to disable HA settings
    VM_PATH_1 = "/Datacenters/#{DC_NAME}/host/#{VM_NAME_1}" #path of above cluster
    VM_PATH_2 = "/Datacenters/#{DC_NAME}/host/#{VM_NAME_2}"#get_vm_mob_ref_by_path

  end

  tests('For a HA cluster, the response should') do
    vm_mob_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::VM_PATH_1)
    response = compute.is_vm_in_ha_cluster('vm_moid'=>vm_mob_ref._ref.to_s)
    test('should return expect true') { response == true }
    response = compute.vm_disable_ha('vm_moid'=>vm_mob_ref._ref.to_s)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.has_key? 'task_state' }
    test('should return success state') { response['task_state'] == 'success'}
  end

  tests('For a non-HA cluster, the response should') do
    vm_mob_ref = compute.get_vm_mob_ref_by_path('path'=>ConstClass::VM_PATH_2)
    response = compute.is_vm_in_ha_cluster('vm_moid'=>vm_mob_ref._ref.to_s)
    test('should return expect false') { response != true }
    response = compute.vm_disable_ha('vm_moid' => vm_mob_ref._ref.to_s)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.has_key? 'task_state' }
    test('should return error state') { response['task_state'] == 'error'}
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.is_vm_in_ha_cluster }
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_disable_ha }
  end

end
