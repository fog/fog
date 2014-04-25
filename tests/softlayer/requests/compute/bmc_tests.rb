Shindo.tests("Fog::Compute[:softlayer] | server requests", ["softlayer"]) do
  tests('success') do

    @sl_connection = Fog::Compute[:softlayer]

    @bmc = {
        :operatingSystemReferenceCode      => 'UBUNTU_LATEST',
        :processorCoreAmount               => 1,
        :memoryCapacity                    => 1,
        :hourlyBillingFlag                 => true,
        :domain                            => 'example.com',
        :hostname                          => 'test',
    }

    tests("#create_bare_metal_server('#{@bmc}')") do
      response = @sl_connection.create_bare_metal_server(@bmc)
      @server_id = response.body['id']
      data_matches_schema(Softlayer::Compute::Formats::BareMetal::SERVER, {:allow_extra_keys => true}) { response.body }
      data_matches_schema(200) { response.status }
    end

    tests("#get_bare_metal_servers()") do
      @sl_connection.get_bare_metal_servers.body.each do |bms|
        data_matches_schema(Softlayer::Compute::Formats::BareMetal::SERVER) { bms }
      end
    end

    tests("#delete_bare_metal_server('#{@server_id})'") do
      response = @sl_connection.delete_bare_metal_server(@server_id)
      data_matches_schema(true) {response.body}
      data_matches_schema(200) {response.status}
    end
  end

  tests('failure') do
    bmc = @bmc.dup; bmc.delete(:hostname)

    tests("#create_bare_metal_server('#{bmc}')") do
      response = @sl_connection.create_bare_metal_server(bmc)
      data_matches_schema('SoftLayer_Exception_MissingCreationProperty'){ response.body['code'] }
      data_matches_schema(500){ response.status }
    end

    tests("#create_bare_metal_server(#{[@bmc]}").raises(ArgumentError) do
      @sl_connection.create_bare_metal_server([@bmc])
    end

    tests("#delete_bare_metal_server('99999999999999')'") do
      response = @sl_connection.delete_bare_metal_server(99999999999999)
      data_matches_schema(String) {response.body}
      data_matches_schema(500) {response.status}
    end

  end
end
