Shindo.tests('Fog::Compute[:ovirt] | servers collection', ['ovirt']) do

  servers = Fog::Compute[:ovirt].servers

  tests('The servers collection') do
    test('should not be empty') { not servers.empty? }
    test('should be a kind of Fog::Compute::Ovirt::Servers') { servers.kind_of? Fog::Compute::Ovirt::Servers }
    tests('should be able to reload itself').succeeds { servers.reload }
    tests('should be able to get a model') do
      tests('by instance uuid').succeeds { servers.get servers.first.id }
    end
  end

end
