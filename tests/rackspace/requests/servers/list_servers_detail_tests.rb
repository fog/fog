Shindo.tests('Rackspace::Servers#list_servers_detail', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'foglistserversdetail').body['server']['id']
      @data = Rackspace[:servers].list_servers_detail.body['servers']
    end

    after do
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::SERVER)
    end

  end
end
