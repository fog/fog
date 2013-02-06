Shindo.tests('Fog::Compute[:digitalocean] | reboot_server request', ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  data = Fog::Compute[:digitalocean].create_server 'fog-test',
                                                   service.flavors.first.id,
                                                   service.images.first.id,
                                                   service.regions.first.id

  tests('success') do

    test('#reboot_server') do
      sleep 120
      data.body['status'] == 'OK' and \
        (service.destroy_server(data.body['droplet']['id']).body['status'] == 'OK')
    end

  end
      

end
