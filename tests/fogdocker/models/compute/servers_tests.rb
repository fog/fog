Shindo.tests('Fog::Compute[:fogdocker] | servers collection', ['fogdocker']) do

  servers = Fog::Compute[:fogdocker].servers

  tests('The servers collection') do
    test('should not be empty') { not servers.empty? }
    test('should be a kind of Fog::Compute::Fogdocker::Servers') { servers.kind_of? Fog::Compute::Fogdocker::Servers }
    tests('should be able to reload itself').succeeds { servers.reload }
    tests('should be able to get a model') do
      tests('by instance uuid').succeeds { servers.get(servers.first.id) }
    end
  end

end
