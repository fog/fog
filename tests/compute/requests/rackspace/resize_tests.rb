Shindo.tests('Rackspace::Compute | resize request', ['rackspace']) do

    @confirm_server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19)

    @revert_server = Rackspace[:compute].servers.create(:flavor_id => 1, :image_id => 19)

    @confirm_server.wait_for { ready? }
    tests("#resize_server(#{@confirm_server.id}, 2) # to confirm").succeeds do
      Rackspace[:compute].resize_server(@confirm_server.id, 2)
    end

    @revert_server.wait_for { ready? }
    tests("#resize_server(#{@revert_server.id}, 2) # to revert").succeeds do
      Rackspace[:compute].resize_server(@revert_server.id, 2)
    end

    @confirm_server.wait_for { status == 'VERIFY_RESIZE' }
    tests("#confirm_resized_server(#{@confirm_server.id})").succeeds do
      Rackspace[:compute].confirm_resized_server(@confirm_server.id)
    end

    @revert_server.wait_for { status == 'VERIFY_RESIZE' }
    tests("#revert_resized_server(#{@revert_server.id})").succeeds do
      Rackspace[:compute].revert_resized_server(@revert_server.id)
    end

    @confirm_server.wait_for { ready? }
    @confirm_server.destroy

    @revert_server.wait_for { ready? }
    @revert_server.destroy

end
