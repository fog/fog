Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  require 'rbvmomi'
  require 'fog'

  class ConstClass
    DC_NAME = 'datacenter'# name of datacenter for test
    CS_NAME = 'cluster01' # cluster name of clone destination
    RP_NAME = 'test' # resource pool name of clone destination
    HOST_NAME = 'w1-vhadp-05.eng.vmware.com' # name of clone destination host
    DATASTORE_NAME = 'datastore01' #  datastore name of clone destination
    RE_VM_NAME = 'node_clone_test_remote' # vm name to clone, which can not access destination datastore
    LC_VM_NAME = 'node_clone_test_local'# vm name to clone, which use the same datastore with destination
    DE_VM_NAME = 'node_clone_test_2ds'# name of a local vm/template to clone from and with two connected datastore
    RE_TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{RE_VM_NAME}" #path of a remote vm template to clone
    LC_TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{LC_VM_NAME}" #path of a local vm template to clone
    DE_TEMPLATE = "/Datacenters/#{DC_NAME}/vm/#{DE_VM_NAME}" #path of a 2-datastore, local vm template to clone
    CPUNUM = 2  # cpu core number
    MEMSIZE = 200 # memory size in Mb
  end

  compute = Fog::Compute[:vsphere]
  response = nil
  response_linked = nil

  tests("Standard Clone | The return value should") do
    dc_ref = compute.get_dc_mob_ref_by_path(ConstClass::DC_NAME)
    target_cr_mob_ref = dc_ref.find_compute_resource(ConstClass::CS_NAME)
    host_mob_ref = target_cr_mob_ref.host.find { |h| h.name == ConstClass::HOST_NAME}
    datastore_mob_ref =  host_mob_ref.datastore.find  { |d| d.name == ConstClass::DATASTORE_NAME}
    rp_mob_ref = target_cr_mob_ref.resourcePool.resourcePool.find {|r| r.name == ConstClass::RP_NAME }

    tests("Standard Clone without destination arguments | The return value should") do
      response = compute.vm_clone('path' => ConstClass::RE_TEMPLATE, 'name' => 'st_cloned_vm_no_des', 'wait' => 1)
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref }.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
    end

    tests("Standard Clone with destination arguments | The return value should") do
      response = compute.vm_clone(
          'path' => ConstClass::RE_TEMPLATE,
          'name' => 'st_cloned_vm',
          'wait' => 1,
          'datastore_moid' => datastore_mob_ref._ref.to_s,
          'rp_moid' => rp_mob_ref._ref.to_s,
          'host_moid'  => host_mob_ref._ref.to_s
      )
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref }.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
    end

  end

  tests("Linked Clone | The return value should") do
    dc_ref = compute.get_dc_mob_ref_by_path(ConstClass::DC_NAME)
    target_cr_mob_ref = dc_ref.find_compute_resource(ConstClass::CS_NAME)
    host_mob_ref = target_cr_mob_ref.host.find { |h| h.name == ConstClass::HOST_NAME}
    datastore_mob_ref =  host_mob_ref.datastore.find  { |d| d.name == ConstClass::DATASTORE_NAME}
    rp_mob_ref = target_cr_mob_ref.resourcePool.resourcePool.find {|r| r.name == ConstClass::RP_NAME }

    tests("Linked Clone with arguments of cpu and memory | The return value should") do
      vm_ref = compute.get_vm_mob_ref_by_path('path' => ConstClass::LC_TEMPLATE)
      response = compute.vm_clone(
          'vm_moid' => vm_ref._ref,
          'name' => 'l_cloned_vm',
          'wait' => 1,
          'linked_clone' => true,
          'cpu' => ConstClass::CPUNUM,
          'memory'=> ConstClass::MEMSIZE)
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref}.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
      test("the return have the right number of cores")do
        response.fetch('cpu') == ConstClass::CPUNUM
      end
      test("the return have the right size of memory")do
        response.fetch('memory') == ConstClass::MEMSIZE
      end
    end

    tests("Linked Clone with destination arguments | The return value should") do
      response = compute.vm_clone(
          'path' => ConstClass::RE_TEMPLATE,
          'name' => 'l_st_cloned_vm',
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

    tests("Linked Clone without destination datastore | The return value should") do
      response = compute.vm_clone(
          'path' => ConstClass::LC_TEMPLATE,
          'name' => 'l_cloned_vm_no_ds',
          'wait' => 1,
          'linked_clone' => true,
          'cluster_moid' => target_cr_mob_ref._ref.to_s,
          'rp_moid' => rp_mob_ref._ref.to_s,
          'host_moid'  => host_mob_ref._ref.to_s
      )
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref }.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
    end

    tests("Linked Clone from a vm with double datastores | The return value should") do
      response = compute.vm_clone(
          'path' => ConstClass::DE_TEMPLATE,
          'name' => 'l_cloned_vm_2ds',
          'wait' => 1,
          'linked_clone' => true,
          'cluster_moid' => target_cr_mob_ref._ref.to_s,
          'rp_moid' => rp_mob_ref._ref.to_s,
          'host_moid'  => host_mob_ref._ref.to_s
      )
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref }.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
      test("include equal number of datastore") do
        des_vm_moid = response.fetch('vm_ref')
        des_vm_ref = compute.get_vm_mob_ref_by_moid(des_vm_moid)
        src_vm_ref = compute.get_vm_mob_ref_by_path('path'=>ConstClass::DE_TEMPLATE)
        des_vm_ref.datastore.size == src_vm_ref.datastore.size
      end

    end

    tests("full clone a vm with double datastores and given dest | The return value should") do
      response = compute.vm_clone(
          'path' => ConstClass::DE_TEMPLATE,
          'name' => 'l_st_cloned_vm_2ds',
          'wait' => 1,
          'linked_clone' => true,
          'datastore_moid' => datastore_mob_ref._ref.to_s,
          'cluster_moid' => target_cr_mob_ref._ref.to_s,
          'rp_moid' => rp_mob_ref._ref.to_s,
          'host_moid'  => host_mob_ref._ref.to_s
      )
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref }.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
      test("include only given datastore") do
        des_vm_moid = response.fetch('vm_ref')
        des_vm_ref = compute.get_vm_mob_ref_by_moid(des_vm_moid)
        des_vm_ref.datastore.size == 1
      end

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
