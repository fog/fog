Shindo.tests('Rackspace::Servers#get_server_details', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'foggetserverdetails').body['server']['id']
      @data = Rackspace[:servers].get_server_details(@server_id).body['server']
    end

    after do
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::SERVER)
    end

  end
  tests('failure') do

    test('raises NotFound error if server does not exist') do
      has_error(Excon::Errors::NotFound) do
        Rackspace[:servers].get_server_details(0)
      end
    end

  end
end
