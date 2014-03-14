Shindo.tests('Fog::Compute::RackspaceV2 | virtual_interfaces', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => rackspace_test_flavor_id(service),
    :image_id => rackspace_test_image_id(service)
  }

  tests('virtual_interfaces') do
    pending if Fog.mocking?
    begin
      @server = service.servers.create options
      @server.wait_for { ready? }

      tests('#virtual_interfaces').succeeds do
        @server.virtual_interfaces.all
      end

    ensure
      @server.destroy if @server
    end
  end
end
