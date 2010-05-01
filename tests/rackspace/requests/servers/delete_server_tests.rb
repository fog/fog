Shindo.tests('Rackspace::Servers#delete_server', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'fogdeleteserver').body['server']['id']
    end

    test('has proper output format') do
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

  end
  tests('failure') do

    test('raises NotFound error if server does not exist') do
      begin
        Rackspace[:servers].delete_server(0)
        false
      rescue Excon::Errors::NotFound
        true
      end
    end

  end
end
