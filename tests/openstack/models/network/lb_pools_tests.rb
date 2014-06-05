Shindo.tests("Fog::Network[:openstack] | lb_pools", ['openstack']) do
  @lb_pool = Fog::Network[:openstack].lb_pools.create(:subnet_id => 'subnet_id',
                                                      :protocol => 'HTTP',
                                                      :lb_method => 'ROUND_ROBIN')
  @lb_pools = Fog::Network[:openstack].lb_pools

  tests('success') do

    tests('#all').succeeds do
      @lb_pools.all
    end

    tests('#get').succeeds do
      @lb_pools.get @lb_pool.id
    end

  end

  @lb_pool.destroy
end
