Shindo.tests('Fog::Compute[:digitalocean] | power on/off/shutdown requests',
             ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  server = fog_test_server

  tests('success') do

    test('#power_off_server') do
      service.power_off_server(server.id).body['status'] == 'OK'
    end

    test('#power_on_server') do
      service.power_on_server(server.id).body['status'] == 'OK'
    end

    test('#shutdown_server') do
      service.shutdown_server(server.id).body['status'] == 'OK'
    end

    server.start

  end

end
