Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  # require 'guid'
  compute = Fog::Compute[:vsphere]
  response = nil
  response_linked = nil

  template = "rhel64"
  datacenter = "Solutions"

  tests("Standard Clone | The return value should") do
    servers_size = compute.servers.size
    response = compute.vm_clone('datacenter' => datacenter, 'template_path' => template, 'name' => 'cloning_vm', 'wait' => true)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref new_vm task_ref }.each do |key|
      test("have a #{key} key") { response.key? key }
    end
    test("creates a new server") { compute.servers.size == servers_size+1 }
    test("new server name is set") { compute.get_virtual_machine(response['new_vm']['id'])['name'] == 'cloning_vm' }
  end

  tests("Standard Clone setting ram and cpu | The return value should") do
    servers_size = compute.servers.size
    response = compute.vm_clone('datacenter' => datacenter, 'template_path' => template, 'name' => 'cloning_vm', 'memoryMB' => '8192', 'numCPUs' => '8', 'wait' => true)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref new_vm task_ref }.each do |key|
      test("have a #{key} key") { response.key? key }
    end
    test("creates a new server") { compute.servers.size == servers_size+1 }
    test("new server name is set") { compute.get_virtual_machine(response['new_vm']['id'])['name'] == 'cloning_vm' }
  end

  tests("Linked Clone | The return value should") do
    servers_size = compute.servers.size
    response = compute.vm_clone('datacenter' => datacenter, 'template_path' => template, 'name' => 'cloning_vm_linked', 'wait' => 1, 'linked_clone' => true)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref new_vm task_ref }.each do |key|
      test("have a #{key} key") { response.key? key }
    end
    test("creates a new server") { compute.servers.size == servers_size+1 }
    test("new server name is set") { compute.get_virtual_machine(response['new_vm']['id'])['name'] == 'cloning_vm_linked' }
  end

  tests("When invalid input is presented") do
    raises(ArgumentError, 'it should raise ArgumentError') { compute.vm_clone(:foo => 1) }
    raises(Fog::Compute::Vsphere::NotFound, 'it should raise Fog::Compute::Vsphere::NotFound when the UUID is not a string') do
      pending # require 'guid'
      compute.vm_clone('instance_uuid' => Guid.from_s(template), 'name' => 'jefftestfoo')
    end
  end
end
