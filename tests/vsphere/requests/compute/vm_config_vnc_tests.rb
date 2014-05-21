Shindo.tests('Fog::Compute[:vsphere] | vm_config_vnc request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  reconfig_target = '50137835-88a1-436e-768e-9b2677076e67'
  vnc_spec = {:port => '5900', :password => 'ssaaa', :enabled => 'true'}

  tests('The response should') do
    response = compute.vm_config_vnc('instance_uuid' => reconfig_target).merge(vnc_spec)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.key? 'task_state' }
  end

  tests('VNC attrs response should') do
    response = compute.vm_get_vnc(reconfig_target)
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a port key') { response.key? :port }
  end
end
