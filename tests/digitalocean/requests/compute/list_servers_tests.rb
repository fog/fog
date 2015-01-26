Shindo.tests('Fog::Compute[:digitalocean] | list_servers request', ['digitalocean', 'compute']) do

  @server_format = {
    'id'             => Integer,
    'name'           => String,
    'image_id'       => Integer,
    'size_id'        => Integer,
    'region_id'      => Integer,
    'backups_active' => Fog::Nullable::Boolean,
    'ip_address'     => Fog::Nullable::String,
    'status'         => String,
    'created_at'     => String
  }

  tests('success') do

    tests('#list_servers') do
      Fog::Compute[:digitalocean].list_servers.body['droplets'].each do |server|
        tests('format').data_matches_schema(@server_format) do
          server
        end
      end
    end

  end

end
