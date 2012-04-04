Shindo.tests('Fog::Compute[:libvirt] | interfaces collection', ['libvirt']) do

  interfaces = Fog::Compute[:libvirt].interfaces

  tests('The interfaces collection') do
    test('should not be empty') { not interfaces.empty? }
    test('should be a kind of Fog::Compute::Libvirt::Interfaces') { interfaces.kind_of? Fog::Compute::Libvirt::Interfaces }
    tests('should be able to reload itself').succeeds { interfaces.reload }
    tests('should be able to get a model') do
      tests('by instance name').succeeds { interfaces.get interfaces.first.name }
    end
  end

end
