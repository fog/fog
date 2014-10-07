Shindo.tests("Fog::Network[:openstack] | networks", ['openstack']) do
  @network = Fog::Network[:openstack].networks.create(:name => 'net_name',
                                                      :shared => false,
                                                      :admin_state_up => true,
                                                      :tenant_id => 'tenant_id')
  @networks = Fog::Network[:openstack].networks

  tests('success') do

    tests('#all').succeeds do
      @networks.all
    end

    tests('#get').succeeds do
      @networks.get @network.id
    end

  end

  @network.destroy
end
