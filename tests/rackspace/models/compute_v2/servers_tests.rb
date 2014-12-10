Shindo.tests('Fog::Compute::RackspaceV2 | servers', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => rackspace_test_flavor_id(service),
    :image_id => rackspace_test_image_id(service)
  }
  collection_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
  end

  tests("#bootstrap").succeeds do
    pending if Fog.mocking?
    @server = service.servers.bootstrap(options)
  end

  if @server
    @server.destroy
  end

end
