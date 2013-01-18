Shindo.tests('Fog::Compute[:libvirt] | volumes collection', ['libvirt']) do

  volumes = Fog::Compute[:libvirt].volumes

  tests('The volumes collection') do
    test('should not be empty') { not volumes.empty? }
    test('should be a kind of Fog::Compute::Libvirt::Volumes') { volumes.kind_of? Fog::Compute::Libvirt::Volumes }
    tests('should be able to reload itself').succeeds { volumes.reload }
    tests('should be able to get a model') do
      tests('by instance uuid').succeeds { volumes.get volumes.first.id }
    end
  end

end
