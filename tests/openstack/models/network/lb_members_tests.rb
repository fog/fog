Shindo.tests("Fog::Network[:openstack] | lb_members", ['openstack']) do
  @lb_member = Fog::Network[:openstack].lb_members.create(:pool_id => 'pool_id',
                                                          :address => '10.0.0.1',
                                                          :protocol_port => '80',
                                                          :weight => 100)
  @lb_members = Fog::Network[:openstack].lb_members

  tests('success') do

    tests('#all').succeeds do
      @lb_members.all
    end

    tests('#get').succeeds do
      @lb_members.get @lb_member.id
    end

  end

  @lb_member.destroy
end
