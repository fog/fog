Shindo.tests('Fog::Compute[:vsphere] | vm_reconfig_cpus request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  reconfig_target = '50137835-88a1-436e-768e-9b2677076e67'
  reconfig_spec = 2

  tests('The response should') do
    response = compute.vm_reconfig_cpus('instance_uuid' => reconfig_target, 'cpus' => reconfig_spec)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.key? 'task_state' }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.vm_reconfig_cpus('cpus' => reconfig_spec) }
    raises(ArgumentError, 'raises ArgumentError when cpus option is missing') { compute.vm_reconfig_cpus('instance_uuid' => reconfig_target) }
  end

end
