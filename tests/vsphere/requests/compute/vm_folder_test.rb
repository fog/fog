Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  require 'rbvmomi'
  require 'fog'

  class ConstClass
    DC_NAME = 'Datacenter2012'# name of datacenter for test
    CS_NAME = 'cluster-fog' # cluster name of clone destination
    RP_NAME = 'test' # resource pool name of clone destination
    HOST_NAME = 'w1-vhadp-05.eng.vmware.com' # name of clone destination host
    DATASTORE_NAME = 'ds01' #  datastore name of clone destination
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

  tests("Linked Clone | The return value should") do
    dc_ref = compute.get_dc_mob_ref_by_path(ConstClass::DC_NAME)
    target_cr_mob_ref = dc_ref.find_compute_resource(ConstClass::CS_NAME)
    host_mob_ref = target_cr_mob_ref.host.find { |h| h.name == ConstClass::HOST_NAME}
    datastore_mob_ref =  host_mob_ref.datastore.find  { |d| d.name == ConstClass::DATASTORE_NAME}
    rp_mob_ref = target_cr_mob_ref.resourcePool.resourcePool.find {|r| r.name == ConstClass::RP_NAME }

    tests("Linked Clone with destination arguments | The return value should") do
      response = compute.vm_clone(
          'path' => ConstClass::LC_TEMPLATE,
          'name' => 'l_st_cloned_vm-2',
          'wait' => 1,
          'linked_clone' => true,
          'datastore_moid' => datastore_mob_ref._ref.to_s,
          'rp_moid' => rp_mob_ref._ref.to_s,
          'host_moid'  => host_mob_ref._ref.to_s,
          'folder_path' => "serengeti_cluster_111/#{ConstClass::CS_NAME}/worker"
      )
      test("be a kind of Hash") { response.kind_of? Hash }
      %w{ vm_ref task_ref }.each do |key|
        test("have a #{key} key") { response.has_key? key }
      end
      vm_mob_ref = compute.get_vm_mob_ref_by_moid(response.fetch('vm_ref'))
      task = vm_mob_ref.PowerOffVM_Task
      compute.wait_for_task(task)
    end
    compute.folder_delete(dc_ref, "serengeti_cluster_111/#{ConstClass::CS_NAME}")
  end

end
