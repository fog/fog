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
      test_attrs = fog_test_server_attributes
      data = Fog::Compute[:digitalocean].create_server(
        fog_server_name,
        test_attrs[:flavor_id],
        test_attrs[:image_id],
        test_attrs[:region_id],
        { private_networking: true,
          ipv6: true,
          user_data: '{key:"abc123"}'
        }
      )
      data.body
    end
  end
end
