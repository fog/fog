Shindo.tests('Rackspace::Compute | reboot request', ['rackspace']) do

  tests('success') do

    @server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogactions')

    @server.wait_for { ready? }

    tests("#reboot_server(#{@server.id})") do
      returns(Rackspace[:compute].reboot_server(@server.id).status) { 202 }
    end

    @server.destroy

  end

end
