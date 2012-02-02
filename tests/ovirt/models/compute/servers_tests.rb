Shindo.tests('Fog::Compute[:ovirt] | servers collection', ['ovirt']) do

  servers = Fog::Compute[:ovirt].servers

  tests('The servers collection') do
    test('should be a kind of Fog::Compute::Ovirt::Servers') { servers.kind_of? Fog::Compute::Ovirt::Servers }
  end

end
