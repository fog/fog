Shindo.tests('Fog::Compute[:digitalocean] | reboot_server request', ['digitalocean', 'compute']) do

  server = fog_test_server

  tests('success') do

    tests('#reboot_server') do
      test('returns 200') do
        service.reboot_server(server.id).status == 200
      end
      test('state is off') do
        server.wait_for { server.status == 'off' }
        server.status == 'off'
      end
    end
    
  end
      

end
