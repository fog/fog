Shindo.tests("Fog::Network[:openstack] | floating_ips", ['openstack']) do
  @floating_ip = Fog::Network[:openstack].floating_ips.create(:floating_network_id => 'f0000000-0000-0000-0000-000000000000')

  @floating_ips = Fog::Network[:openstack].floating_ips

  tests('success') do

    tests('#all').succeeds do
      @floating_ips.all
    end

    tests('#get').succeeds do
      @floating_ips.get @floating_ip.id
    end

  end

  @floating_ip.destroy
end
