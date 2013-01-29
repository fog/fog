Shindo.tests('Fog::Compute[:digitalocean] | create_server request', ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]

  tests('success') do

    test('#create_server') do
      data = Fog::Compute[:digitalocean].create_server 'fog-test',
                                                       service.flavors.first.id,
                                                       service.images.first.id,
                                                       service.regions.first.id
      # wait some time before destroying the server
      # otherwise the request could be ignored, YMMV
      sleep 120
      data.body['status'] == 'OK' and \
        (service.destroy_server(data.body['droplet']['id']).body['status'] == 'OK')
    end

  end
      

end
