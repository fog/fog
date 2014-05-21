Shindo.tests('Fog::Compute[:vsphere] | vm_migrate request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  powered_on_vm = '50137835-88a1-436e-768e-9b2677076e67'

  tests('The response should') do
    response = compute.vm_migrate('instance_uuid' => powered_on_vm)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.key? 'task_state' }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_migrate }
  end
end
