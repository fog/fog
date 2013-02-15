Shindo.tests('Fog::Compute[:rackspace] | resize request', ['rackspace']) do

    @service = Fog::Compute.new(:provider => :rackspace, :version => :v1)

    @confirm_server =  @service.servers.create(:flavor_id => 1, :image_id => 19)

    @revert_server =  @service.servers.create(:flavor_id => 1, :image_id => 19)

    @confirm_server.wait_for { ready? }
    tests("#resize_server(#{@confirm_server.id}, 2) # to confirm").succeeds do
       @service.resize_server(@confirm_server.id, 2)
    end

    @revert_server.wait_for { ready? }
    tests("#resize_server(#{@revert_server.id}, 2) # to revert").succeeds do
       @service.resize_server(@revert_server.id, 2)
    end

    @confirm_server.wait_for { state == 'VERIFY_RESIZE' }
    tests("#confirm_resized_server(#{@confirm_server.id})").succeeds do
       @service.confirm_resized_server(@confirm_server.id)
    end

    @revert_server.wait_for { state == 'VERIFY_RESIZE' }
    tests("#revert_resized_server(#{@revert_server.id})").succeeds do
       @service.revert_resized_server(@revert_server.id)
    end

    @confirm_server.wait_for { ready? }
    @confirm_server.destroy

    @revert_server.wait_for { ready? }
    @revert_server.destroy

end
