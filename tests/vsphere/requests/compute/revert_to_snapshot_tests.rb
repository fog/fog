Shindo.tests('Fog::Compute[:vsphere] | revert_to_snapshot request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  tests('The response should') do
    response = compute.revert_to_snapshot(Fog::Compute::Vsphere::Snapshot.new(service: 1))
    test('be a kind of Hash') { response.kind_of? Hash }
    test('should have a task_state key') { response.key? 'state' }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when input param is missing') { compute.revert_to_snapshot(nil) }
  end

end
