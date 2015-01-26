Shindo.tests('Fog::Rackspace::Networking | virtual_interface_tests', ['rackspace']) do
  @service = Fog::Rackspace::Networking.new

  virtual_interface_format = {
    "virtual_interfaces"=> [{
      "ip_addresses"=> [{
        "network_id"=> String,
        "network_label"=> String,
        "address"=> String
      }],
      "id"=> String,
      "mac_address"=> String
    }]
  }

  begin
    unless Fog.mocking?
      network_id = nil

      @server = @service.servers.create(:name => "fog_virtual_interface_test_#{Time.now.to_i.to_s}",
                                        :flavor_id => rackspace_test_flavor_id(@service),
                                        :image_id => rackspace_test_image_id(@service))
      @server.wait_for { ready? }

      @network = @service.networks.create(:label => "fog_#{Time.now.to_i.to_s}", :cidr => '192.168.0.0/24')
    end

    tests('success') do
      pending if Fog.mocking?

      tests('#create_virtual_interface').formats(virtual_interface_format) do
        response = @service.create_virtual_interface @server.id, @network.id
        body = response.body
        @virtual_network_interface_id = body["virtual_interfaces"].first["id"]
        body
      end
        tests('#list_virtual_interfaces').formats(virtual_interface_format) do
          @service.list_virtual_interfaces(@server.id).body
        end

        tests('#delete_virtual_interfaces').succeeds do
          @service.delete_virtual_interface(@server.id, @virtual_network_interface_id)
        end
      end
  ensure
    @server.destroy if @server
    delete_test_network @network
  end
end
