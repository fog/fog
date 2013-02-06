Shindo.tests('Fog::Compute[:digitalocean] | power_cycle_server request', ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    tests('#power_cycle_server') do
      test('returns 200') do
        service.power_cycle_server(server.id).status == 200
      end
      test('state is off') do
        server.wait_for { server.status == 'off' }
        server.status == 'off'
      end
    end
    
  end
      

end
