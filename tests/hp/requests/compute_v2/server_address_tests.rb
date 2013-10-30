Shindo.tests("Fog::Compute::HPV2 | server address requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  tests('success') do
    @server_name = 'fogaddresstests'
    @server_id = nil

    # check to see if there are any existing servers, otherwise create one
    if (data = service.list_servers(:status => 'ACTIVE').body['servers'][0])
      @server_id = data['id']
    else
      #@server = service.servers.create(:name => @server_name, :flavor_id => 100, :image_id => @base_image_id)
      #@server.wait_for { ready? }
      data = service.create_server(@server_name, 100, @base_image_id).body['server']
      @server_id = data['id']
    end

    # the network name is currently named 'private'
    tests("#list_server_addresses(#{@server_id})").formats({'addresses' => {'hpcloud' => [{'version' => Integer, 'addr' => String}]}}) do
      service.list_server_addresses(@server_id).body
    end

    tests("#list_server_addresses_by_network(#{@server_id}, 'network_name')").succeeds do
      service.list_server_addresses_by_network(@server_id, 'network_name').body
    end

    service.delete_server(@server_id)

  end

  tests('failure') do

    tests('#list_server_addresses(0)').raises(Fog::Compute::HPV2::NotFound) do
      service.list_server_addresses(0)
    end

    tests("#list_server_addresses_by_network(0, 'network_name')").raises(Fog::Compute::HPV2::NotFound) do
      service.list_server_addresses_by_network(0, 'network_name')
    end

  end

end
