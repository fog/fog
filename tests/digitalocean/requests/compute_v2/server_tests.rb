Shindo.tests('Fog::Compute::DigitalOceanV2 | create_server request', ['digitalocean', 'compute']) do
  service = Fog::Compute.new(:provider => 'DigitalOcean', :version => 'V2')

  server_format = {
    'id'         => Integer,
    'name'       => String,
    'memory'     => Integer,
    'vcpus'      => Integer,
    'disk'       => Integer,
    'locked'     => Fog::Boolean,
    'created_at' => String,
  }

  create_server_format = {
    'droplet' => {
      'id'           => Integer,
      'name'         => String,
      'memory'       => Integer,
      'vcpus'        => Integer,
      'disk'         => Integer,
      'locked'       => Fog::Boolean,
      'status'       => String,
      'kernel'       => Hash,
      "created_at"   => String,
      "features"     => Array,
      "backup_ids"   => Array,
      "snapshot_ids" => Array,
      "image"        => Hash,
      "size"         => Hash,
      "size_slug"    => String,
      "networks"     => Hash,
      "region"       => Hash,
    },

    'links'   => {
      "actions" => Array,
    }

  }

  tests('success') do

    server_id   = nil
    server_name = "fog-#{Time.now.to_i.to_s}"
    image       = "ubuntu-14-04-x64"
    region      = "nyc3"
    size        = "512mb"

    tests("#create_server(#{server_name}, #{size}, #{image}, #{region})").formats(create_server_format) do
      body      = service.create_server(server_name, size, image, region).body
      server_id = body['droplet']['id']
      body
    end

    test('#get_server_details can retrieve by id') do
      body = service.get_server_details(server_id).body
      tests('format').data_matches_schema(server_format) do
        body['droplet']
      end
    end

    server = service.servers.get(server_id)
    server.wait_for { ready? }

    tests('#delete_server').succeeds do
      server.delete
    end

    tests('#list_servers') do
      service.list_servers.body['droplets'].each do |droplet|
        tests('format').data_matches_schema(server_format) do
          droplet
        end
      end
    end
  end
end
