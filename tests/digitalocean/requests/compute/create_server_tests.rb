Shindo.tests('Fog::Compute[:digitalocean] | create_server request', ['digitalocean', 'compute']) do

  @server_format = {
    'id'             => Integer,
    'name'           => String,
    'image_id'       => Integer,
    'size_id'        => Integer,
    'event_id'       => Integer 
  }

  service = Fog::Compute[:digitalocean]

  tests('success') do

    tests('#create_server').formats({'status' => 'OK', 'droplet' => @server_format}) do
      image = service.images.find { |img| img.name == 'Ubuntu 12.04 x64 Server' }
      flavor = service.flavors.find { |f| f.name == '512MB' }
      data = Fog::Compute[:digitalocean].create_server 'fog-test-server',
                                                       flavor.id,
                                                       image.id,
                                                       service.regions.first.id
      data.body
    end
    
  end
      

end
