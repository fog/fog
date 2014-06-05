Shindo.tests('Fog::Compute[:xenserver] | PIFs collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]

  tests('The pifs collection') do
    pifs = conn.pifs.all

    test('should not be empty') { !pifs.empty? }

    test('should be a kind of Fog::Compute::XenServer::Pifs') { pifs.kind_of? Fog::Compute::XenServer::Pifs }

    tests('should be able to reload itself').succeeds { pifs.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        pifs.get(pifs.first.reference).is_a? Fog::Compute::XenServer::PIF
      }
    end

  end

end
