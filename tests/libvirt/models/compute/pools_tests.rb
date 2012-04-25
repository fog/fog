Shindo.tests('Fog::Compute[:libvirt] | pools request', ['libvirt']) do

  pools = Fog::Compute[:libvirt].pools

  tests('The pools collection') do
      test('should not be empty') { not pools.empty? }
      test('should be a kind of Fog::Compute::Libvirt::Pools') { pools.kind_of? Fog::Compute::Libvirt::Pools }
      tests('should be able to reload itself').succeeds { pools.reload }
      tests('should be able to get a model') do
        tests('by instance id').succeeds { pools.get pools.first.uuid }
      end
    end
end
