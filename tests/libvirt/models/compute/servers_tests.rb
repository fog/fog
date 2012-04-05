Shindo.tests('Fog::Compute[:libvirt] | servers collection', ['libvirt']) do

  servers = Fog::Compute[:libvirt].servers

  tests('The servers collection') do
    test('should not be empty') { not servers.empty? }
    test('should be a kind of Fog::Compute::Libvirt::Servers') { servers.kind_of? Fog::Compute::Libvirt::Servers }
    tests('should be able to reload itself').succeeds { servers.reload }
    tests('should be able to get a model') do
      tests('by instance uuid').succeeds { servers.get servers.first.id }
    end
  end

end
