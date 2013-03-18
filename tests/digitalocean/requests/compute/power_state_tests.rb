Shindo.tests('Fog::Compute[:digitalocean] | power on/off/shutdown requests', 
             ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  server = fog_test_server

  tests('success') do

    test('#power_off_server') do
      server.wait_for(120) { ready? }
      service.power_off_server(server.id)
      server.wait_for(120) { !ready? }
      server.status == 'off'
    end

    test('#power_on_server') do
      service.power_on_server server.id
      server.wait_for(120) { ready? }
      server.ready?
    end
    
    test('#shutdown_server') do
      service.shutdown_server server.id
      server.wait_for(120) { !ready? }
      server.status == 'off'
    end
    
    # restore status
    server.start

  end

end
