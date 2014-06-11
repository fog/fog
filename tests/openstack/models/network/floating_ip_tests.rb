Shindo.tests("Fog::Network[:openstack] | floating_ip", ['openstack']) do

  tests('success') do

    tests('#create').succeeds do
      @instance = Fog::Network[:openstack].floating_ips.create(:floating_network_id => 'f0000000-0000-0000-0000-000000000000')

      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.port_id = 'p0000000-0000-0000-0000-000000000000'
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end

end
