Shindo.tests('Rackspace::Servers#reboot_server', 'rackspace') do
  tests('success') do

    before do
      @server_id = Rackspace[:servers].create_server(1, 3, 'fogrebootserver').body['server']['id']
    end

    after do
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

    tests('HARD') do
      test('has proper output format') do
        Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
        Rackspace[:servers].reboot_server(@server_id, 'HARD')
      end
    end

    tests('SOFT') do
      test('has proper output format') do
        Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
        Rackspace[:servers].reboot_server(@server_id, 'SOFT')
      end
    end

  end
  tests('failure') do

    test('raises NotFound error if server does not exist') do
      has_error(Excon::Errors::NotFound) do
        Rackspace[:servers].reboot_server(0)
      end
    end

  end

end
