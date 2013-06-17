require 'shindo_helper'
Shindo.tests('Fog::Compute[:digitalocean] | get_server_details request', ['digitalocean', 'compute']) do

  tests('success') do

    test('#get_server_details') do
      server = fog_test_server
      body = Fog::Compute[:digitalocean].get_server_details(server.id).body
      body['droplet']['name'] == 'fog-test-server'
    end

  end

end
