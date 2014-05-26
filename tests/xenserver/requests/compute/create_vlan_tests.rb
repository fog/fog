Shindo.tests('Fog::Compute[:xenserver] | create_vlan request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests('success') do
    test('#create_vlan') do
      @net = compute.networks.create :name => 'test-net'

      # try to use a bonded interface first
      @pif = compute.pifs.find { |p| p.device == 'bond0' and p.vlan == "-1" }
      unless @pif
        @pif = compute.pifs.find { |p| p.device == 'eth0' and p.vlan == "-1" }
      end

      @ref = compute.create_vlan @pif.reference, 1499, @net.reference
      @ref.start_with? "OpaqueRef"
    end
  end

  tests('failure') do
    test('#create_vlan duplicated') do
      raises = false
      # Try to create a VLAN with a duplicated tag
      begin
        @ref = compute.create_vlan @pif.reference, 1499, @net.reference
      rescue Fog::XenServer::RequestFailed => e
        raises = true if (e.message =~ /NETWORK_ALREADY_CONNECTED/)
      end
      raises
    end
  end

  compute.destroy_vlan @ref
  @net.destroy

end
