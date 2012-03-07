Shindo.tests('Fog::Compute[:vsphere] | vm_reconfig_memory request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  reconfig_target = '50137835-88a1-436e-768e-9b2677076e67'
  reconfig_spec = 4096

  tests('The response should') do
    response = compute.vm_reconfig_memory('instance_uuid' => reconfig_target, 'memory' => reconfig_spec)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.has_key? 'task_state' }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_reconfig_memory('memory' => reconfig_spec) }
    raises(ArgumentError, 'raises ArgumentError when memory option is missing') { compute.vm_reconfig_memory('instance_uuid' => reconfig_target) }
  end

end
