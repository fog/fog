Shindo.tests('Rackspace::Compute | resize request', ['rackspace']) do

  tests('success_confirm') do

    @server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogresize')

    @server.wait_for { ready? }

    tests("#resize_server(#{@server.id}, 2)") do
      returns(Rackspace[:compute].resize_server(@server.id, 2).status) { 202 }
      returns(Rackspace[:compute].get_server_details(@server.id).body['server']['status']) { 'VERIFY_RESIZE' }
    end

    tests("#confirm_resize(#{@server.id})") do
      returns(Rackspace[:compute].confirm_resize(@server.id).status) { 204 }
      returns(Rackspace[:compute].get_server_details(@server.id).body['server']['status']) { 'ACTIVE' }
    end

    @server.destroy

  end

  tests('success_revert') do

    @server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogresize')

    @server.wait_for { ready? }

    tests("#resize_server(#{@server.id}, 2)") do
      returns(Rackspace[:compute].resize_server(@server.id, 2).status) { 202 }
      returns(Rackspace[:compute].get_server_details(@server.id).body['server']['status']) { 'VERIFY_RESIZE' }
    end

    tests("#revert_resize(#{@server.id})") do
      returns(Rackspace[:compute].revert_resize(@server.id).status) { 202 }
      returns(Rackspace[:compute].get_server_details(@server.id).body['server']['status']) { 'ACTIVE' }
    end

    @server.destroy

  end

end
