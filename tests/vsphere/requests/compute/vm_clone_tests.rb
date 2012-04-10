Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  #require 'guid'
  require 'rubygems'
  require 'rbvmomi'
  require 'Fog'
  compute = Fog::Compute[:vsphere]

  response = nil
  response_linked = nil

  class ConstClass
    DC_NAME = 'DatacenterCF'# name of test datacenter
    VM_NAME = 'knife' # name of vm/template to clone from
    CS_NAME = 'Cluster1' # name of clone detination cluster
    RP_NAME = 'RP1' # name of clone destination resource pool
    HOST_NAME = '10.117.8.187' # name of clone destination host
    DATASTORE_NAME = 'LDISK01' #  name of datacenter to clone from
    TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{VM_NAME}" #path of a vm template to clone
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

  tests("Linked Clone | The return value should") do
    dc_ref = compute.get_dc_mob_ref_by_path(ConstClass::DC_NAME)
    target_cr_mob_ref = dc_ref.find_compute_resource(ConstClass::CS_NAME)
    host_mob_ref = target_cr_mob_ref.host.find { |h| h.name == ConstClass::HOST_NAME}
    datastore_mob_ref =  host_mob_ref.datastore.find  { |d| d.name == ConstClass::DATASTORE_NAME}
    rp_mob_ref = target_cr_mob_ref.resourcePool.resourcePool.find {|r| r.name == ConstClass::RP_NAME }
    response = compute.vm_clone(
        'path' => ConstClass::TEMPLATE,
        'name' => 'cloning_vm_linked1',
        'wait' => 1,
        'linked_clone' => true,
        'datastore_moid' => datastore_mob_ref._ref.to_s,
        'rp_moid' => rp_mob_ref._ref.to_s,
        'host_moid'  => host_mob_ref._ref.to_s
    )
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Standard Clone | The return value should") do
    response = compute.vm_clone(
        'path' => ConstClass::TEMPLATE,
        'name' => 'cloning_vm2',
        'wait' => 1,
        'target_cluster' => ConstClass::CS_NAME,
        'target_rp' => ConstClass::RP_NAME,
        'target_host'  => ConstClass::HOST_NAME
    )
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("Linked Clone | The return value should") do
    response = compute.vm_clone(
        'path' => ConstClass::TEMPLATE,
        'name' => 'cloning_vm_linked2',
        'wait' => 1,
        'linked_clone' => true,
        'target_cluster' => ConstClass::CS_NAME,
        'target_rp' => ConstClass::RP_NAME,
        'target_host'  => ConstClass::HOST_NAME
    )
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
