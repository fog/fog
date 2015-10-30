Shindo.tests('Fog::Compute[:vsphere] | vm_take_snapshot request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  powered_off_vm = nil

  tests('The response should') do
    response = compute.vm_take_snapshot('instance_uuid' => powered_off_vm, 'name' => 'foobar')
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.key? 'task_state' }
    test('should have a was_cancelled key') { response.key? 'was_cancelled' }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_take_snapshot('name' => 'foobar') }
    raises(ArgumentError, 'raises ArgumentError when name option is missing') { compute.vm_take_snapshot('instance_uuid' => powered_off_vm) }
  end

end
