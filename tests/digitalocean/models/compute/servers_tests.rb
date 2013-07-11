Shindo.tests('Fog::Compute[:digitalocean] | servers collection', ['digitalocean']) do
  service = Fog::Compute[:digitalocean]

  options = {
    :name => "#{fog_server_name}-#{Time.now.to_i.to_s}"
  }.merge fog_test_server_attributes

  collection_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
  end

end
