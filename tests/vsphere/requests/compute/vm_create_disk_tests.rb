Shindo.tests("Fog::Compute[:vsphere] | vm_create_disk request", 'vsphere') do

  require 'rubygems'
  require 'rbvmomi'
  require 'Fog'
  require 'guid'

  compute = Fog::Compute[:vsphere]

  response = nil
  response_linked = nil

  tests("Get vm management object by id | The return value should") do
    response = compute.get_vm_mob_by_id('vm-471')
    test("be a kind of mob of VirtualMachine") { response.class.to_s == "VirtualMachine"}
    test("equal to input moid or not") { response._ref.to_s == "vm-471"}
  end

  tests("Get datastore name by vmdk path | The return value should") do
    response = compute.get_ds_name_by_path('[DS91733] knife/knife_2.vmdk')
    test("equal to corresponding ds name contained by path") { response == "DS91733"}
  end

  template = "/Datacenters/DatacenterCF/vm/knife"
  tests("Standard disk create by vm management object id | The return value should") do
    response = compute.vm_create_disk('vm_moid' => 'vm-471','vmdk_path' => '[DS91733] knife/knife_2.vmdk', 'disk_size'=> 200)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref vm_attributes vm_dev_number_increase task_state}.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
    test("increase disk device for given vm") { response.fetch('vm_dev_number_increase') >= 1}
    test("create disk success or not")  { response.fetch('task_state').to_s == 'success'}
  end

  template = "/Datacenters/DatacenterCF/vm/knife"
  tests("Standard disk create by uuid | The return value should") do
    response = compute.vm_create_disk('instance_uuid' => '5001a218-732b-2f5c-e8a7-e0599f2900bb','vmdk_path' => '[DS91733] knife/knife_3.vmdk', 'disk_size'=> 200)
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
      compute.vm_create_disk('instance_uuid' => Guid.from_s(template), 'vmdk_path' => '[DS91733] knife/knife_3.vmdk', 'disk_size'=> 200)
    end
  end
end
