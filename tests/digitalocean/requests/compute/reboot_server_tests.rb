Shindo.tests('Fog::Compute[:digitalocean] | reboot_server request', ['digitalocean', 'compute']) do

  pending # See https://github.com/fog/fog/pull/3304

  server = fog_test_server

  tests('success') do

    tests('#reboot_server').succeeds do
      service.reboot_server(server.id).body['status'] == 'OK'
    end

  end


end
