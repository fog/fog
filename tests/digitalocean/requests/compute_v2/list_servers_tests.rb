Shindo.tests('Fog::Compute::DigitalOceanV2 | list_servers request', ['digitalocean', 'compute']) do
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

  tests('success') do
    tests('#list_servers') do
      service.list_servers.body['droplets'].each do |server|
        tests('format').data_matches_schema(server_format) do
          server
        end
      end
    end
  end
end