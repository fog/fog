Shindo.tests('Fog::Compute[:xenserver] | pbds collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]
  
  tests('The pbds collection') do
    pbds = conn.pbds.all

    test('should not be empty') { !pbds.empty? }

    test('should be a kind of Fog::Compute::XenServer::Pbds') { pbds.kind_of? Fog::Compute::XenServer::Pbds }

    tests('should be able to reload itself').succeeds { pbds.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds { 
        pbds.get(pbds.first.reference).is_a? Fog::Compute::XenServer::PBD
      }
    end

  end

end
