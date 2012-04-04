Shindo.tests('Fog::Compute[:libvirt] | nics collection', ['libvirt']) do

  nics = Fog::Compute[:libvirt].servers.first.nics

  tests('The nics collection') do
    test('should not be empty') { not nics.empty? }
    test('should be a kind of Array') { nics.kind_of? Array }
  end

end
