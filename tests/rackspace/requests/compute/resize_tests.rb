Shindo.tests('Fog::Compute[:rackspace] | resize request', ['rackspace']) do

    @confirm_server = Fog::Compute[:rackspace].servers.create(:flavor_id => 1, :image_id => 19)

    @revert_server = Fog::Compute[:rackspace].servers.create(:flavor_id => 1, :image_id => 19)

    @confirm_server.wait_for { ready? }
    tests("#resize_server(#{@confirm_server.id}, 2) # to confirm").succeeds do
      Fog::Compute[:rackspace].resize_server(@confirm_server.id, 2)
    end

    @revert_server.wait_for { ready? }
    tests("#resize_server(#{@revert_server.id}, 2) # to revert").succeeds do
      Fog::Compute[:rackspace].resize_server(@revert_server.id, 2)
    end

    @confirm_server.wait_for { state == 'VERIFY_RESIZE' }
    tests("#confirm_resized_server(#{@confirm_server.id})").succeeds do
      Fog::Compute[:rackspace].confirm_resized_server(@confirm_server.id)
    end

    @revert_server.wait_for { state == 'VERIFY_RESIZE' }
    tests("#revert_resized_server(#{@revert_server.id})").succeeds do
      Fog::Compute[:rackspace].revert_resized_server(@revert_server.id)
    end

    @confirm_server.wait_for { ready? }
    @confirm_server.destroy

    @revert_server.wait_for { ready? }
    @revert_server.destroy

end
