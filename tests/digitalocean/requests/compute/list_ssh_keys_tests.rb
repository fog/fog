Shindo.tests('Fog::Compute[:digitalocean] | list_ssh_keys request', ['digitalocean', 'compute']) do

  @ssh_key_format = {
    'id'           => Integer,
    'name'         => String
  }

  tests('success') do

    tests('#list_ssh_keys') do
      Fog::Compute[:digitalocean].create_ssh_key 'fookey', 'ssh-dss FOO'
      Fog::Compute[:digitalocean].list_ssh_keys.body['ssh_keys'].each do |key|
        tests('format').data_matches_schema(@ssh_key_format) do
          key
        end
      end
    end

  end

end
