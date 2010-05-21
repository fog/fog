Shindo.tests('Rackspace::Servers#reboot_server', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogrebootserver')

    before do
      @server.wait_for { ready? }
    end

    tests("#reboot_server(#{@server.id}, 'HARD')").succeeds do
      Rackspace[:servers].reboot_server(@server.id, 'HARD')
    end

    tests("#reboot_server(#{@server.id}, 'SOFT')").succeeds do
      Rackspace[:servers].reboot_server(@server.id, 'SOFT')
    end

    @server.wait_for { ready? }
    @server.destroy

  end
  tests('failure') do

    tests('#reboot_server(0)').raises(Excon::Errors::NotFound) do
      Rackspace[:servers].reboot_server(0)
    end

  end

end
