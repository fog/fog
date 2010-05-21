Shindo.tests('Rackspace::Servers#list_servers_detail', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foglistserversdetail')

    tests('#list_servers_detail').formats({'servers' => [Rackspace::Servers::Formats::SERVER]}) do
      Rackspace[:servers].list_servers_detail.body
    end

    @server.wait_for { ready? }
    @server.destroy

  end
end
