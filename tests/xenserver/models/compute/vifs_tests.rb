Shindo.tests('Fog::Compute[:xenserver] | VIFs collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]

  tests('The vifs collection') do
    vifs = conn.vifs.all

    test('should not be empty') { !vifs.empty? }

    test('should be a kind of Fog::Compute::XenServer::Vifs') { vifs.kind_of? Fog::Compute::XenServer::Vifs }

    tests('should be able to reload itself').succeeds { vifs.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        vifs.get(vifs.first.reference).is_a? Fog::Compute::XenServer::VIF
      }
    end

  end

end
