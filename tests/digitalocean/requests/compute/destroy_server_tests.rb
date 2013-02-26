Shindo.tests('Fog::Compute[:digitalocean] | reboot_server request', ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  data = fog_test_server

  tests('success') do

    test('#reboot_server') do
      sleep 120
      data.body['status'] == 'OK' and \
        (service.destroy_server(data.body['droplet']['id']).body['status'] == 'OK')
    end

  end
      

end
