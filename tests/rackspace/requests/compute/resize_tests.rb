Shindo.tests('Rackspace::Compute | resize request', ['rackspace']) do

  tests('confirm') do

    @server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19)

    @server.wait_for { ready? }

    tests("#resize_server(#{@server.id}, 2)").succeeds do
      Rackspace[:compute].resize_server(@server.id, 2)
    end

    @server.wait_for { status == 'VERIFY_RESIZE' }

    tests("#confirm_resized_server(#{@server.id})").succeeds do
      Rackspace[:compute].confirm_resized_server(@server.id)
    end

    @server.wait_for { ready? }

    @server.destroy

  end

  tests('revert') do

    @server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19)

    @server.wait_for { ready? }

    tests("#resize_server(#{@server.id}, 2)").succeeds do
      Rackspace[:compute].resize_server(@server.id, 2)
    end

    @server.wait_for { status == 'VERIFY_RESIZE' }

    tests("#revert_resized_server(#{@server.id})").succeeds do
      Rackspace[:compute].revert_resized_server(@server.id)
    end

    @server.wait_for { ready? }

    @server.destroy

  end

end
