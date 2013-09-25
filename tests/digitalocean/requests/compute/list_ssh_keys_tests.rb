Shindo.tests('Fog::Compute[:digitalocean] | list_ssh_keys request', ['digitalocean', 'compute']) do

  @ssh_key_format = {
    'id'           => Integer,
    'name'         => String
  }

  tests('success') do

    ssh_key = service.create_ssh_key 'fookey', 'ssh-dss FOO'

    tests('#list_ssh_keys') do
      service.list_ssh_keys.body['ssh_keys'].each do |key|
        tests('format').data_matches_schema(@ssh_key_format) do
          key
        end
      end
    end

    service.destroy_ssh_key(ssh_key.body['ssh_key']['id'])

  end

end
