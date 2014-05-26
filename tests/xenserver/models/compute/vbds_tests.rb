Shindo.tests('Fog::Compute[:xenserver] | VBDs collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]

  tests('The vbds collection') do
    vbds = conn.vbds.all

    test('should not be empty') { !vbds.empty? }

    test('should be a kind of Fog::Compute::XenServer::Vbds') { vbds.kind_of? Fog::Compute::XenServer::Vbds }

    tests('should be able to reload itself').succeeds { vbds.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        vbds.get(vbds.first.reference).is_a? Fog::Compute::XenServer::VBD
      }
    end

  end

end
