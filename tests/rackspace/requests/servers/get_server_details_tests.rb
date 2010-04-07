Shindo.tests('Rackspace::Servers#get_server_details', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'fogcreateserver').body['server']['id']
      @data = Rackspace[:servers].get_server_details(@server_id).body['server']
    end

    after do
      wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

    test('has proper output format') do
      validate_format(@data, Rackspace::Servers::Formats::SERVER)
    end

  end
  tests('failure') do

    test('raises NotFound error if server does not exist') do
      begin
        Rackspace[:servers].get_server_details(0)
        false
      rescue Excon::Errors::NotFound
        true
      end
    end

  end
end
