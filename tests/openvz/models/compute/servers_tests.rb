Shindo.tests('Fog::Compute[:openvz] | servers collection', ['openvz']) do

  openvz_service =  Fog::Compute[:openvz]

  tests('The servers collection') do
    servers = openvz_service.servers.all

    server = openvz_fog_test_server

    test('should NOT be empty') do
      servers.reload
      !servers.empty?
    end

    test('should be a kind of Fog::Compute::Openvz::Servers') do
      servers.kind_of? Fog::Compute::Openvz::Servers
    end

    tests('should have Fog::Compute::Openvz::Servers inside') do
      servers.each do |s|
        test { s.kind_of? Fog::Compute::Openvz::Server }
      end
    end

    tests('should be able to reload itself').succeeds { servers.reload }

    tests('should be able to get a model') do
      test('by instance ctid') do
        servers.get(server.ctid).kind_of? Fog::Compute::Openvz::Server
      end
    end

  end

end
