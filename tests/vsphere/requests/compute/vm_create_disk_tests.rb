Shindo.tests("Fog::Compute[:vsphere] | vm_create_disk request", 'vsphere') do

  require 'rubygems'
  require 'rbvmomi'
  require 'Fog'
  require 'guid'

  compute = Fog::Compute[:vsphere]

  response = nil
  response_linked = nil
  vm_moid = nil
  vm_uuid = nil

  class ConstClass
    TEMPLATE = "/Datacenters/DatacenterCF/vm/knife" #path of a vm which need create disks
    MOB_TYPE = 'VirtualMachine' # type refereed to an effective VirtualMachine management object
    DS_NAME =  'DS91733'# name referring to a datastore which include vmdks need to re-config
    VMDK_PATH1 = "[#{DS_NAME}] knife/knife_2.vmdk" #path of a vmdk to re-config which belong to above mentioned datastore
    VMDK_PATH2 = "[#{DS_NAME}] knife/knife_3.vmdk" #path of a vmdk to re-config which belong to above mentioned datastore
    VMDK_PATH3 = "[#{DS_NAME}] knife/knife_4.vmdk" #path of a vmdk to re-config which belong to above mentioned datastore
    DISK_SIZE = 200
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

  tests("Get datastore name by vmdk path | The return value should") do
    response = compute.get_ds_name_by_path( ConstClass::VMDK_PATH1)
    test("equal to corresponding ds name contained by path") { response == ConstClass::DS_NAME}
  end

  tests("Standard disk create by vm management object id | The return value should") do
    response = compute.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)
    vm_moid = response._ref.to_s
    response = compute.vm_create_disk(
        'vm_moid' => vm_moid,
        'vmdk_path' => ConstClass::VMDK_PATH1 ,
        'disk_size'=> ConstClass::DISK_SIZE.to_i
    )
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref vm_attributes vm_dev_number_increase task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("increase disk device for given vm") { response.fetch('vm_dev_number_increase') >= 1}
    test("create disk success or not")  { response.fetch('task_state').to_s == 'success'}
  end

  tests("Standard disk create by uuid | The return value should") do
    response = compute.get_vm_mob_ref_by_path('path' => ConstClass::TEMPLATE)
    vm_uuid = response.config.instanceUuid
    response = compute.vm_create_disk(
        'instance_uuid' => vm_uuid,
        'vmdk_path' => ConstClass::VMDK_PATH2,
        'disk_size'=> ConstClass::DISK_SIZE.to_i
    )
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref vm_attributes vm_dev_number_increase task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("increase disk device for given vm") { response.fetch('vm_dev_number_increase') >= 1}
    test("create disk success or not")  { response.fetch('task_state').to_s == 'success'}
  end

  tests("When invalid input is presented") do
    raises(ArgumentError, 'it should raise ArgumentError') { compute.vm_create_disk(:foo => 1) }
    raises(Fog::Compute::Vsphere::NotFound, 'it should raise Fog::Compute::Vsphere::NotFound when the UUID is not a string') do
      pending # require 'guid'
      compute.vm_create_disk('instance_uuid' => Guid.from_s(template), 'vmdk_path' => ConstClass::VMDK_PATH3, 'disk_size'=> ConstClass::DISK_SIZE.to_i)
    end
  end
end
