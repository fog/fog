Shindo.tests("Fog::Compute[:cloudstack] | public_ip_address", "cloudstack") do
  config = compute_providers[:cloudstack]
  compute = Fog::Compute[:cloudstack]

  model_tests(compute.public_ip_addresses, config[:public_ip_address_attributes], config[:mocked]) do
    @server = Fog::Compute[:cloudstack].servers.create(config[:server_attributes])
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    tests('#server') do
      test(' == @server') do
        @instance.reload
        @instance.server_id == @server.id
      end
    end

    test('#server = nil') do
      @instance.server = nil
      @instance.server_id.nil?
    end

    @server.destroy
  end
end
