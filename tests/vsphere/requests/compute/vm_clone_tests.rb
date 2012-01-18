Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  #require 'guid'
  
  compute = Fog::Compute[:vsphere]
  response = nil
  response_linked = nil

  template = "/Datacenters/Solutions/vm/Jeff/Templates/centos56gm2"
  tests("Standard Clone | The return value should") do
    response = compute.vm_clone('path' => template, 'name' => 'cloning_vm', 'wait' => 1)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end
  template = "/Datacenters/Solutions/vm/Jeff/Templates/cloning_vm"
  tests("Linked Clone | The return value should") do
    response_linked = compute.vm_clone('path' => template, 'name' => 'cloning_vm_linked', 'wait' => 1)
    test("be a kind of Hash") { response_linked.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response_linked.has_key? key }
    end
  end
  ## clean up afterward as in the aws tests.
  compute.vm_power_off('uuid' => response_linked['vm_attributes']['uuid'],  'instance_uuid' => response_linked['vm_attributes']['instance_uuid'], 'force' => 1)
  compute.vm_destroy('instance_uuid' => response_linked['vm_attributes']['instance_uuid'])
  compute.vm_power_off('uuid' => response['vm_attributes']['uuid'],  'instance_uuid' => response['vm_attributes']['instance_uuid'], 'force' => 1)
  compute.vm_destroy('instance_uuid' => response['vm_attributes']['instance_uuid'])
  
  tests("When invalid input is presented") do
    raises(ArgumentError, 'it should raise ArgumentError') { compute.vm_clone(:foo => 1) }
    raises(Fog::Compute::Vsphere::NotFound, 'it should raise Fog::Compute::Vsphere::NotFound when the UUID is not a string') do
      pending # require 'guid'
      compute.vm_clone('instance_uuid' => Guid.from_s(template), 'name' => 'jefftestfoo')
    end
  end
end
