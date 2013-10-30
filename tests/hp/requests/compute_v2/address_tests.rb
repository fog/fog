Shindo.tests("Fog::Compute::HPV2 | address requests", ['hp', 'v2', 'compute', 'address']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @floating_ips_format = {
    'instance_id' => Fog::Nullable::String,
    'ip'          => Fog::Nullable::String,
    'fixed_ip'    => Fog::Nullable::String,
    'id'          => String
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || "7f60b54c-cd15-433f-8bed-00acbcd25a17"

  tests('success') do

    @server_name = 'fogservertest'
    @server_id = nil

    @server = service.servers.create(:name => @server_name, :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }
    #data = service.create_server(@server_name, 100, @base_image_id).body['server']
    #@server_id = data['id']

    tests("#list_addresses").formats({'floating_ips' => [@floating_ips_format]}) do
      service.list_addresses.body
    end

    tests("#allocate_address").formats(@floating_ips_format) do
      data = service.allocate_address.body['floating_ip']
      @address_id = data['id']
      @ip_address = data['ip']
      data
    end

    tests("#get_address('#{@address_id}')").formats(@floating_ips_format) do
      service.get_address(@address_id).body['floating_ip']
    end

    tests("#associate_address('#{@server.id}', '#{@ip_address}')").succeeds do
      service.associate_address(@server.id, @ip_address)
      #tests("#get_address").returns(@ip_address, "server has associated ip address") do
      #  @server.reload
      #  @server.addresses['custom'][0]['addr']
      #end
    end

    #tests("#disassociate_address('#{@server.id}', '#{@ip_address}')").succeeds do
    #  service.disassociate_address(@server.id, @ip_address)
    #end

    tests("#release_address('#{@address_id}')").succeeds do
      service.release_address(@address_id)
    end

    @server.destroy
    #service.delete_server(@server_id)

  end

  tests('failure') do

    tests("#get_address('invalidaddress', 'invalidip')").raises(Fog::Compute::HPV2::NotFound) do
      service.get_address('invalidaddress')
    end

    tests("#associate_address('invalidserver', 'invalidip')").raises(Excon::Errors::InternalServerError) do
      service.associate_address('invalidserver', 'invalidip')
    end

    tests("#disassociate_address('invalidserver', 'invalidip')").raises(Excon::Errors::InternalServerError) do
      service.disassociate_address('invalidserver', 'invalidip')
    end

    tests("#release_address('invalidaddress')").raises(Fog::Compute::HPV2::NotFound) do
      service.release_address('invalidaddress')
    end

  end

end
