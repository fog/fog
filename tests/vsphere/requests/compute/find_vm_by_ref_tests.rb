Shindo.tests('Fog::Compute[:vsphere] | find_vm_by_ref request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  tests("When missing arguments") do
    raises(ArgumentError, "Should raise ArgumentError when missing :vm_ref") do
      compute.find_vm_by_ref
    end
    raises(Fog::Compute::Vsphere::NotFound, "Should raise Fog::Compute::Vsphere::NotFound when the vm does not exist") do
      compute.find_vm_by_ref('vm_ref' => 'vm-000')
    end
  end

  # centos56gm is a template
  existing_vms = { 'vm-715' => 'jefftest', 'vm-698' => 'centos56gm' }

  tests("When looking for existing VM's the response") do
    existing_vms.each do |ref,name|
      response = compute.find_vm_by_ref('vm_ref' => ref)
      test("should be a kind of Hash") { response.kind_of? Hash }
      test("should have virtual_machine key") { response.has_key? 'virtual_machine' }
      returns(name, "#{ref} should return #{name}") { response['virtual_machine']['name'] }
    end
  end

end
