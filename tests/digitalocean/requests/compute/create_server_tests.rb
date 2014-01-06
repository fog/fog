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
      image = service.images.find { |i| i.name == 'Ubuntu 13.10 x64' }
      image_id = image.nil? ? 1505447 : image.id
      region = service.regions.find { |r| r.name == 'New York 1' }
      region_id = region.nil? ? 4 : region.id
      flavor = service.flavors.find { |r| r.name == '512MB' }
      flavor_id = flavor.nil? ? 66 : flavor.id

      data = Fog::Compute[:digitalocean].create_server(
        fog_server_name,
        flavor_id,
        image_id,
        region_id
      )
      data.body
    end
  end
end
