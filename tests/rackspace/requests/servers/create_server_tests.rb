Shindo.tests('Rackspace::Servers#create_server', 'rackspace') do
  tests('success') do

    @server_id = nil

    tests('#create_server(1, 19)').formats(Rackspace::Servers::Formats::SERVER.merge('adminPass' => String)) do
      # 1 => 256MB, 19 => Gentoo
      data = Rackspace[:servers].create_server(1, 19).body['server']
      @server_id = data['id']
      data
    end

    @server = Rackspace[:servers].servers.get(@server_id)
    @server.wait_for { ready? }
    @server.destroy

  end
end
