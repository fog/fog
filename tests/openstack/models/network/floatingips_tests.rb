Shindo.tests("Fog::Network[:openstack] | floatingips", ['openstack']) do
  @floatingip = Fog::Network[:openstack].floatingips.create(:floating_network_id => 'f0000000-0000-0000-0000-000000000000')









  @floatingips = Fog::Network[:openstack].floatingips

  tests('success') do

    tests('#all').succeeds do
      @floatingips.all
    end

    tests('#get').succeeds do
      @floatingips.get @floatingip.id
    end

  end

  @floatingip.destroy
end
