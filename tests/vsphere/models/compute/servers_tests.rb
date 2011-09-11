Shindo.tests('Fog::Compute[:vsphere] | servers collection', ['vsphere']) do

  servers = Fog::Compute[:vsphere].servers

  tests('The servers collection') do
    test('should not be empty') { not servers.empty? }
    test('should be a kind of Fog::Compute::Vsphere::Servers') { servers.kind_of? Fog::Compute::Vsphere::Servers }
    tests('should be able to reload itself').succeeds { servers.reload }
    tests('should be able to get a model') do
      tests('by managed object reference').succeeds { servers.get 'vm-715' }
      tests('by instance uuid').succeeds { servers.get '5032c8a5-9c5e-ba7a-3804-832a03e16381' }
    end
  end

end
