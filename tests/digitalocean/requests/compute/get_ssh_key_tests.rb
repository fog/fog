Shindo.tests('Fog::Compute[:digitalocean] | get_ssh_keys request', ['digitalocean', 'compute']) do

  @ssh_key_format = {
    'id'             => Integer,
    'name'           => String,
    'ssh_pub_key'    => String,
  }

  service = Fog::Compute[:digitalocean]

  tests('success') do

    tests('#get_ssh_key') do
      key = service.create_ssh_key 'fookey', 'ssh-dss FOO'

      tests('format').data_matches_schema(@ssh_key_format) do
        service.get_ssh_key(key.body['ssh_key']['id']).body['ssh_key']
      end

      service.destroy_ssh_key(key.body['ssh_key']['id'])
    end

  end

end
