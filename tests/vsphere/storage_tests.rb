Shindo.tests("Fog::Storage[:vsphere] | query resources request", ['vsphere']) do

  require 'rbvmomi'
  require 'fog'

  # need set down below consts according to real VSphere data center
  class ConstClass
    DC_NAME = 'Datacenter2012'# name of test datacenter
    CS_NAME1 = 'cluster-fog' # name referring to a cluster sits in above datacenter
    CS_NAME2 = 'cluster-ws' # name referring to a cluster sits in above datacenter
    HOST_NAME1 = 'w1-vhadp-05.eng.vmware.com' # name referring to a host sits in above cluster
    HOST_NAME2 = 'w1-vhadp-02.eng.vmware.com' # name referring to a host sits in above cluster
    VM_NAME1 = 'node_network_test' # name referring to a vm sits in above host
    VM_NAME2 = 'node_network_test2' # name referring to a vm sits in above host
    VM_REQ_MEM = 64 # unit -> m
    VM_SYSTEM_SIZE = 1024
    VM_SWAP_SIZE = 1024
    VM_DATA_SIZE = 1024 * 128
  end

  storage = Fog::Storage[:vsphere]
  clusters =[]
  clusters <<  ConstClass::CS_NAME1

  tests("When fetch storage resources of given cluster") do
    response = storage.fetch_resources(clusters)
    test("it should return hash of hosts belong to given clusters") do
      response.kind_of? Hash
    end
    tests("The response should") do
      test("contain at least one host") { response.length >= 1 }
      test("contain values of HostResource Object") do
        response.values[0].kind_of? Fog::Storage::Vsphere::Shared::HostResource
      end
    end
  end

  vms = []
  vm = Fog::Storage::Vsphere::Shared::VM.new(
      'name'=> ConstClass::VM_NAME1,
      'req_mem'=> ConstClass::VM_REQ_MEM,
      'system_size'=> ConstClass::VM_SYSTEM_SIZE,
      'swap_size'=> ConstClass::VM_SWAP_SIZE,
      'data_size'=> ConstClass::VM_DATA_SIZE
  )
  vms << vm
  hosts = []
  tests("When query storage capacity to filter out hosts") do
    hosts <<  ConstClass::HOST_NAME2
    response = storage.query_capacity(vms,'hosts'=> hosts)
    test("it should return array of hosts with enough capacity in given clusters") do
      response.kind_of? Array
    end
    tests("The response should") do
      test("contain no host") { response.size ==0 }
    end
    hosts <<  ConstClass::HOST_NAME1
    response = storage.query_capacity(vms,'hosts'=> hosts)
    test("it should return array of hosts with enough capacity in given clusters") do
      response.kind_of? Array
    end
    tests("The response should") do
      test("contain at least one host") { response.size >= 1 }
    end
  end

  hosts = []
  tests("When recommend host and disk arrangement solution for given vms") do
    hosts <<  ConstClass::HOST_NAME1
    response = storage.recommmdation(vms, hosts)
    puts "response = #{response}"
    test("it should return hash of host and disk arrangement for a given vm") do
      response.kind_of? Hash
    end
    tests("The response should") do
      test("contain only host") { response.size ==1 }
      test("vm should include host name") {response.has_key?(ConstClass::HOST_NAME1) }
      vm = response[ConstClass::HOST_NAME1][0]
      #vm.inspect_unit_number
      vm.inspect_volume_size
      #vm.inspect_fullpath
      puts "------------------finish recommendation vm1----------------------"
    end
    vm_2 = Fog::Storage::Vsphere::Shared::VM.new(
        'name'=> ConstClass::VM_NAME2,
        'req_mem'=> ConstClass::VM_REQ_MEM,
        'system_size'=> ConstClass::VM_SYSTEM_SIZE,
        'swap_size'=> ConstClass::VM_SWAP_SIZE,
        'data_size'=> ConstClass::VM_DATA_SIZE
    )
    vms << vm_2
    response2 = storage.recommmdation(vms, hosts)
    puts "response2 = #{response2}"
    test("it should return hash of host and disk arrangement for group vms") do
      response.kind_of? Hash
    end
    tests("The response should") do
      test("contain only host") { response2.size ==1 }
      test("vm should include host name") {response2.has_key?(ConstClass::HOST_NAME1)}
      vm_2 = response2[ConstClass::HOST_NAME1][1]
      #vm_2.inspect_unit_number
      vm_2.inspect_volume_size
      #vm_2.inspect_fullpath
      puts "-----------------finish recommendation vm1 vm2------------------"
    end
  end

  vm_arr = []
  vm_arr << vm
  tests("When commit claimed storage for given vms") do
    response = storage.commission(vm_arr)
    test("it should return difference after this commission given") do
      response > 0
    end
    tests("The response should") do
      test("less than or equal to storage claimed by given vms") do
        response <= (ConstClass::VM_SYSTEM_SIZE + ConstClass::VM_SWAP_SIZE + ConstClass::VM_DATA_SIZE)
      end
    end
    tests("When de-commit claimed storage for given vms") do
      response2 = storage.decommission(vm_arr)
      test("it should return difference after this decommission given") do
        response2 > 0
      end
      tests("The response should") do
        test("less than or equal to storage claimed by given vms") do
          response2 <= (ConstClass::VM_SYSTEM_SIZE + ConstClass::VM_SWAP_SIZE + ConstClass::VM_DATA_SIZE)
        end
        test("equal to the storage claimed in commission operation") do
          response2 == response
        end
      end
    end
  end

  vm.id = storage.get_mob_ref_by_name('VirtualMachine',ConstClass::VM_NAME1)._ref.to_s
  tests("When create vmdk for given vm") do
    response = storage.create_volumes(vm)
    puts "_______________response of create_volumes is #{response}___________"
    test("it should return status result after this create task") do
      response.has_key? ('task_state')
    end
    #tests("When delete vmdk for given vm") do
    #  response2 = storage.delete_volumes(vm)
    #  test("it should return status result after this delete task") do
    #    response2.has_key? ('task_state')
    #  end
    #end
  end

end # Shindo end of all tests





