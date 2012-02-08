Shindo.tests('Fog::Compute[:ovirt] | vm_destroy request', ['ovirt']) do

  compute = Fog::Compute[:ovirt]
  if compute.servers.all(:search => 'fog-*').empty?
    compute.create_vm(:name => 'fog-'+Time.now.to_i.to_s, :cluster_name => 'Default')
  end
  vm_id = compute.servers.all(:search => 'fog-*').last.id

  tests('The response should') do
    response = compute.destroy_vm(:id => vm_id)
    test('be a success') { response ? true: false }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when id option is missing') { compute.destroy_vm }
  end

end
