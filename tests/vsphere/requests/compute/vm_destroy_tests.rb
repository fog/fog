Shindo.tests('Fog::Compute[:vsphere] | vm_destroy request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  booted_vm = '5032c8a5-9c5e-ba7a-3804-832a03e16381'

  tests('The response should') do
    response = compute.vm_destroy('instance_uuid' => booted_vm)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.has_key? 'task_state' }

  end
  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_destroy }
  end

end
