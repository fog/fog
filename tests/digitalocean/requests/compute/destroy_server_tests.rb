Shindo.tests('Fog::Compute[:digitalocean] | destroy_server request', ['digitalocean', 'compute']) do

  service = Fog::Compute[:digitalocean]
  server = fog_test_server

  tests('success') do

    test('#destroy_server') do
      service.destroy_server(server.id).body['status'] == 'OK'
    end

  end
      

end
