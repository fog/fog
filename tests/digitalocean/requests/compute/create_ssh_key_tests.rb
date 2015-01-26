Shindo.tests('Fog::Compute[:digitalocean] | create_ssh_key request', ['digitalocean', 'compute']) do

  @key_format = {
    'id'             => Integer,
    'name'           => String,
    'ssh_pub_key'    => String
  }

  service = Fog::Compute[:digitalocean]

  tests('success') do

    tests('#create_ssh_key').formats({'status' => 'OK', 'ssh_key' => @key_format}) do
      @key = Fog::Compute[:digitalocean].create_ssh_key 'fookey', 'fookey'
      @key.body
    end

  end

  service.destroy_ssh_key @key.body['ssh_key']['id']

end
