Shindo.tests("Fog::Compute[:servers] | vm_clone request") do
  require 'guid'
  template = "50323f93-6835-1178-8b8f-9e2109890e1a"
  compute = Fog::Compute[:vsphere]

  tests("The return value should") do
    response = compute.vm_clone('instance_uuid' => template, 'name' => 'cloning_vm')
    test("be a kind of Hash") { response.kind_of? Hash }
    %w{ vm_ref task_ref }.each do |key|
      test("have a #{key} key") { response.has_key? key }
    end
  end
  tests("When invalid input is presented") do
    raises(ArgumentError, 'it should raise ArgumentError') { compute.vm_clone(:foo => 1) }
    raises(Fog::Vsphere::Errors::ServiceError,
           'it should raise ServiceError if a VM already exists with the provided name') do
      compute.vm_clone('instance_uuid' => '123', 'name' => 'jefftest')
    end
    raises(Fog::Compute::Vsphere::NotFound, 'it should raise Fog::Compute::Vsphere::NotFound when the UUID is not a string') do
      compute.vm_clone('instance_uuid' => Guid.from_s(template), 'name' => 'jefftestfoo')
    end
  end
end
