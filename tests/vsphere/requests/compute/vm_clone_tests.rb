Shindo.tests("Fog::Compute[:vsphere] | vm_clone request", 'vsphere') do
  # require 'guid'
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

  template = "/Datacenters/Solutions/vm/Jeff/Templates/centos56gm2"
  tests("Linked Clone | The return value should") do
    response = compute.vm_clone('path' => template, 'name' => 'cloning_vm_linked', 'wait' => 1, 'linked_clone' => true)
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end

  tests("When invalid input is presented") do
    raises(ArgumentError, 'it should raise ArgumentError') { compute.vm_clone(:foo => 1) }
    raises(Fog::Compute::Vsphere::NotFound, 'it should raise Fog::Compute::Vsphere::NotFound when the UUID is not a string') do
      pending # require 'guid'
      compute.vm_clone('instance_uuid' => Guid.from_s(template), 'name' => 'jefftestfoo')
    end
  end
end
