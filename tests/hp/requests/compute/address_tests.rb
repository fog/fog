Shindo.tests('Fog::Compute[:hp] | address requests', ['hp']) do

  @floating_ips_format = {
    'instance_id' => Fog::Nullable::Integer,
    'ip'          => Fog::Nullable::String,
    'fixed_ip'    => Fog::Nullable::String,
    'id'          => Integer
  }

  tests('success') do

    tests("#list_addresses").formats({'floating_ips' => [@floating_ips_format]}) do
      Fog::Compute[:hp].list_addresses.body
    end

    tests("#allocate_address").formats(@floating_ips_format) do
      data = Fog::Compute[:hp].allocate_address.body['floating_ip']
      @address_id = data['id']
      @ip_address = data['ip']
      data
    end

    @server = Fog::Compute[:hp].servers.create(:name => 'fogaddresstests', :flavor_id => 100, :image_id => 1242)
    @server.wait_for { ready? }

    tests("#associate_address('#{@server.id}', '#{@ip_address}')").succeeds do
      Fog::Compute[:hp].associate_address(@server.id, @ip_address)
    end

    tests("#disassociate_address('#{@server.id}', '#{@ip_address}')").succeeds do
      Fog::Compute[:hp].disassociate_address(@server.id, @ip_address)
    end

    @server.destroy

    tests("#release_address('#{@address_id}')").succeeds do
      Fog::Compute[:hp].release_address(@address_id)
    end

  end

  tests('failure') do

    tests("#associate_address('invalidserver', 'invalidip')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].associate_address('invalidserver', 'invalidip')
    end

    tests("#disassociate_address('invalidserver', 'invalidip')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].disassociate_address('invalidserver', 'invalidip')
    end

    tests("#release_address('invalidip')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].release_address('invalidip')
    end

  end

end
