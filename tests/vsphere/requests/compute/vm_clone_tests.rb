Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  #require 'guid'
  require 'rubygems'
  require 'rbvmomi'
  require 'Fog'
  compute = Fog::Compute[:vsphere]

  response = nil
  response_linked = nil

  class ConstClass
    TEMPLATE = "/Datacenters/DatacenterCF/vm/knife" #path of a vm template to clone which belong to datacenter-457
    RP_MOID = 'resgroup-509'# which is named as below resource_pool
    HOST_MOID = 'host-456' # which is named as below host_name
    DS_MOID =  'datastore-457'# which is a datastore accessible from the cluster of cs_name and host of host_name
    CS_NAME = 'Cluster1' # which have a resource_pool named as rp_name and host named as host_name
    RP_NAME = 'RP1' # name of above referred resource pool
    HOST_NAME = '10.117.8.187' # name of above referred host
  end

  tests("Standard Clone | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'cloning_vm', 'wait' => 1)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Linked Clone | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'cloning_vm_linked', 'wait' => 1, 'linked_clone' => true)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Standard Clone | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'cloning_vm1', 'wait' => 1, 'datastore_moid' => ConstClass::DS_MOID, 'rp_moid' => ConstClass::RP_MOID, 'host_moid'  => ConstClass::HOST_MOID)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Linked Clone | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'cloning_vm_linked1', 'wait' => 1, 'linked_clone' => true, 'datastore_moid' => ConstClass::DS_MOID, 'rp_moid' => ConstClass::RP_MOID, 'host_moid'  => ConstClass::HOST_MOID)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Standard Clone | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'cloning_vm2', 'wait' => 1, 'target_cluster' => ConstClass::CS_NAME, 'target_rp' => ConstClass::RP_NAME, 'target_host'  => ConstClass::HOST_NAME)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Linked Clone | The return value should") do
    response = compute.vm_clone('path' => ConstClass::TEMPLATE, 'name' => 'cloning_vm_linked2', 'wait' => 1, 'linked_clone' => true,  'target_cluster' => ConstClass::CS_NAME, 'target_rp' => ConstClass::RP_NAME, 'target_host'  => ConstClass::HOST_NAME)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("When invalid input is presented") do
    raises(ArgumentError, 'it should raise ArgumentError') { compute.vm_clone(:foo => 1) }
    raises(Fog::Compute::Vsphere::NotFound, 'it should raise Fog::Compute::Vsphere::NotFound when the UUID is not a string') do
      pending # require 'guid'
      compute.vm_clone('instance_uuid' => Guid.from_s(ConstClass::TEMPLATE), 'name' => 'jefftestfoo')
    end
  end
end
