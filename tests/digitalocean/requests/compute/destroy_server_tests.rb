Shindo.tests('Fog::Compute[:digitalocean] | destroy_server request', ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  server = fog_test_server

  tests('success') do

    test('#destroy_server') do
      service.destroy_server(server.id).body['status'] == 'OK'
      service.servers.get(server.id) == nil
    end

  end
end
