Shindo.tests('Fog::Compute[:xenserver] | destroy_vlan request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests('success') do
    test('#destroy_vlan') do
      @net = compute.networks.create :name => 'test-net'

      # try to use a bonded interface first
      @pif = compute.pifs.find { |p| p.device == 'bond0' and p.vlan == "-1" }
      unless @pif
        @pif = compute.pifs.find { |p| p.device == 'eth0' and p.vlan == "-1" }
      end

      @ref = compute.create_vlan @pif.reference, 1499, @net.reference
      compute.destroy_vlan @ref
      (compute.vlans.reload.find { |v| v.reference == @ref }).nil?
    end
  end
  
  tests('failure') do
    test('#destroy_vlan invalid') do
      raises = false
      # Try to create a VLAN with a duplicated tag
      begin
        compute.destroy_vlan @ref
      rescue Fog::XenServer::RequestFailed => e
        raises = true if (e.message =~ /HANDLE_INVALID/)
      end
      raises
    end
  end

  @net.destroy
  
end
