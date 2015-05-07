Shindo.tests('Fog::Compute[:opennebula] | flavors collection', ['opennebula']) do

  flavors = Fog::Compute[:opennebula].flavors

  tests('The flavors collection should') do
    test('should be a kind of Fog::Compute::OpenNebula::Flavors') { flavors.kind_of? Fog::Compute::OpenNebula::Flavors }
    tests('should be able to reload itself').succeeds { flavors.reload }

    tests('should be able to get models') do
      tests('all').succeeds { flavors.all }
      tests('by instance id').succeeds { flavors.get flavors.first.id }
      tests('by name').succeeds { flavors.get_by_name "fogtest" }
      tests('by filter').succeeds { flavors.get_by_filter ({:name => "fogtest", :id => flavors.first.id }) }
    end
  end
end
