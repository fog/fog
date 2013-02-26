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
      data = Fog::Compute[:digitalocean].create_server 'fog-test-server',
                                                       service.flavors.first.id,
                                                       service.images.first.id,
                                                       service.regions.first.id
      data.body
    end
    
  end
      

end
