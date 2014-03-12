Shindo.tests('Fog::Compute::RackspaceV2 | virtual_interface', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  net_options = {
    :label => "fog_network_#{Time.now.to_i.to_s}",
    :cidr => '192.168.0.0/24'
  }

  server_options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => rackspace_test_flavor_id(service),
    :image_id => rackspace_test_image_id(service)
  }

  tests('virtual_interface') do
    pending if Fog.mocking?
    begin
      @server = service.servers.create server_options
      @network = service.networks.create net_options
      @server.wait_for { ready? }

      model_tests(@server.virtual_interfaces, {:network => @network}, false)

    ensure
      if @server
        @server.destroy
        # wait_for_server_deletion(@server) if @server
        delete_test_network(@network) if @network
      end
    end
  end

end
