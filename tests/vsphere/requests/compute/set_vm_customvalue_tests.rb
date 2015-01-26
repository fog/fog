Shindo.tests('Fog::Compute[:vsphere] | set_vm_customvalue request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  instance_uuid = '50137835-88a1-436e-768e-9b2677076e67'
  custom_key = nil
  custom_value = nil

  tests('The response should') do
    response = compute.set_vm_customvalue(instance_uuid, custom_key, custom_value)
    test('be nil') { response.nil? }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when instance_uuid option is missing') { compute.set_vm_customvalue }
    raises(ArgumentError, 'raises ArgumentError when custom_key option is missing') { compute.set_vm_customvalue(instance_uuid) }
    raises(ArgumentError, 'raises ArgumentError when custom_value option is missing') { compute.set_vm_customvalue(instance_uuid, custom_key) }
  end

end
