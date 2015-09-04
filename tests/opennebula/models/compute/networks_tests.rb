Shindo.tests('Fog::Compute[:opennebula] | networks collection', ['opennebula']) do

  networks = Fog::Compute[:opennebula].networks

  tests('The networks collection') do
    test('should be a kind of Fog::Compute::OpenNebula::Networks') { networks.kind_of? Fog::Compute::OpenNebula::Networks }
    tests('should be able to reload itself').succeeds { networks.reload }
    tests('should be able to get a model') do
      tests('all').succeeds { networks.all }
      tests('by instance id').succeeds { networks.get networks.first.id }
      tests('by filter').succeeds { networks.get_by_filter ({ :id => networks.first.id }) }
      tests('by name').succeeds { networks.get_by_name ("fogtest") }
    end
  end

end
