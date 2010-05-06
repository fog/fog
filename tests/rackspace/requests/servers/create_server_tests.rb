Shindo.tests('Rackspace::Servers#create_server', 'rackspace') do
  tests('success') do

    before do
      # 1 => 256MB, 3 => Gentoo
      @data = Rackspace[:servers].create_server(1, 3).body['server']
      @server_id = @data['id']
    end

    after do
      Fog.wait_for { Rackspace[:servers].get_server_details(@server_id).body['server']['status'] == 'ACTIVE' }
      Rackspace[:servers].delete_server(@server_id)
    end

    test('has proper output format') do
      has_format(@data, Rackspace::Servers::Formats::SERVER.merge('adminPass' => String))
    end

  end
end
