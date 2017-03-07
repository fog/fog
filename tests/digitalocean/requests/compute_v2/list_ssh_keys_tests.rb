Shindo.tests('Fog::Compute::DigitalOceanV2 | list_ssh_keys request', ['digitalocean', 'compute']) do
  service = Fog::Compute.new(:provider => 'DigitalOcean', :version => 'V2')

  ssh_key_format = {
    'id' => Integer,
    'fingerprint' => String,
    'public_key' => String,
    'name' => String,
  }

  tests('success') do
    tests('#list_ssh_keys') do
      service.list_ssh_keys.body['ssh_keys'].each do |ssh_key|
        tests('format').data_matches_schema(ssh_key_format) do
          ssh_key
        end
      end
    end
  end
end
