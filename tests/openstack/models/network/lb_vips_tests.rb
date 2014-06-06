Shindo.tests("Fog::Network[:openstack] | lb_vips", ['openstack']) do
  @lb_vip = Fog::Network[:openstack].lb_vips.create(:subnet_id => 'subnet_id',
                                                    :pool_id => 'pool_id',
                                                    :protocol => 'HTTP',
                                                    :protocol_port => 80)
  @lb_vips = Fog::Network[:openstack].lb_vips

  tests('success') do

    tests('#all').succeeds do
      @lb_vips.all
    end

    tests('#get').succeeds do
      @lb_vips.get @lb_vip.id
    end

  end

  @lb_vip.destroy
end
