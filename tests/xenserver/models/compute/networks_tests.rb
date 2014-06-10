Shindo.tests('Fog::Compute[:xenserver] | Networks collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]

  tests('The networks collection') do
    networks = conn.networks.all

    test('should not be empty') { !networks.empty? }

    test('should be a kind of Fog::Compute::XenServer::Networks') { networks.kind_of? Fog::Compute::XenServer::Networks }

    tests('should be able to reload itself').succeeds { networks.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        networks.get(networks.first.reference).is_a? Fog::Compute::XenServer::Network
      }
    end

  end

end
