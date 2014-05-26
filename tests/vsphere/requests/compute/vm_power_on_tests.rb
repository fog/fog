Shindo.tests('Fog::Compute[:vsphere] | vm_power_on request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  powered_off_vm = nil

  tests('The response should') do
    response = compute.vm_power_on('instance_uuid' => powered_off_vm)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.key? 'task_state' }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_power_on }
  end

end
