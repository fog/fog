Shindo.tests('Fog::Compute[:digitalocean] | get_server_details request', ['digitalocean', 'compute']) do

  tests('success') do

    test('#get_server_details') do
      server = fog_test_server
      body = Fog::Compute[:digitalocean].get_server_details(server.id).body
      body['droplet']['name'] == fog_server_name
    end

  end

end
