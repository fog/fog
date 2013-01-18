Shindo.tests("Fog::Compute[:hp] | address requests", ['hp', 'address']) do

  @floating_ips_format = {
    'instance_id' => Fog::Nullable::Integer,
    'ip'          => Fog::Nullable::String,
    'fixed_ip'    => Fog::Nullable::String,
    'id'          => Integer
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

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

    tests("#get_address('#{@address_id}')").formats(@floating_ips_format) do
      Fog::Compute[:hp].get_address(@address_id).body['floating_ip']
    end

    @server = Fog::Compute[:hp].servers.create(:name => 'fogaddresstests', :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }

    tests("#associate_address('#{@server.id}', '#{@ip_address}')").succeeds do
      Fog::Compute[:hp].associate_address(@server.id, @ip_address)
      tests("#get_address").returns(@ip_address, "server has associated ip address") do
        @server.reload
        @server.addresses['private'][1]['addr']
      end
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

    tests("#get_address('invalidaddress', 'invalidip')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].get_address('invalidaddress')
    end

    tests("#associate_address('invalidserver', 'invalidip')").raises(Excon::Errors::InternalServerError) do
      Fog::Compute[:hp].associate_address('invalidserver', 'invalidip')
    end

    tests("#disassociate_address('invalidserver', 'invalidip')").raises(Excon::Errors::InternalServerError) do
      Fog::Compute[:hp].disassociate_address('invalidserver', 'invalidip')
    end

    tests("#release_address('invalidaddress')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].release_address('invalidaddress')
    end

  end

end
