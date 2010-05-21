Shindo.tests('Rackspace::Servers#list_servers', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foglistservers')

    tests('#list_servers').formats({'servers' => [Rackspace::Servers::Formats::SUMMARY]}) do
      Rackspace[:servers].list_servers.body
    end

    @server.wait_for { ready? }
    @server.destroy

  end
end
