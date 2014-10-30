Shindo.tests('Fog::Compute[:ovirt] | update_volume request', ['ovirt']) do

  compute = Fog::Compute[:ovirt]
  if compute.servers.all(:search => 'fog-*').empty?
    compute.create_vm(:name => 'fog-'+Time.now.to_i.to_s, :cluster_name => 'Default')
  end
  vm_id = compute.servers.all(:search => 'fog-*').last

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when vm id is missing') { compute.update_volume(nil, {:id => 1}) }
    raises(ArgumentError, 'raises ArgumentError when disk_id option is missing') { compute.update_volume(1, {:any => 1}) }
  end

  tests('The response should') do
    response = compute.update_volume(vm_id, :id => 1)
    test('be a success') { response ? true: false }
  end


end
