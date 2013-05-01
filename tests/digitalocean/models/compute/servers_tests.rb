Shindo.tests('Fog::Compute[:digitalocean] | servers collection', ['digitalocean']) do

  service =  Fog::Compute[:digitalocean]

  tests('The servers collection') do
    servers = service.servers.all

    server = fog_test_server

    test('should NOT be empty') do
      servers.reload
      !servers.empty? 
    end

    test('should be a kind of Fog::Compute::DigitalOcean::Servers') do 
      servers.kind_of? Fog::Compute::DigitalOcean::Servers 
    end

    tests('should have Fog::Compute::DigitalOcean::Servers inside') do
      servers.each do |s|
        test { s.kind_of? Fog::Compute::DigitalOcean::Server }
      end
    end

    tests('should be able to reload itself').succeeds { servers.reload }

    tests('should be able to get a model') do
      test('by instance id') do
        servers.get(server.id).kind_of? Fog::Compute::DigitalOcean::Server
      end
    end

  end

end
