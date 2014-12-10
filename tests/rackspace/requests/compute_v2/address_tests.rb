Shindo.tests('Fog::Compute::RackspaceV2 | address requests', ['rackspace']) do

  @service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  image_id  = rackspace_test_image_id(@service)
  flavor_id = rackspace_test_flavor_id(@service)

  tests('success') do
    unless Fog.mocking?
      @server = @service.servers.create(:flavor_id => flavor_id, :image_id => image_id, :name => "address-tests-#{Time.now.to_i}")
      @server.wait_for { ready? }
      @server_id = @server.id
    else
      @server_id = 42
    end

    address_format =  { "addresses"=> {
      "private" => [{"addr" => String, "version" => Integer}],
      "public" => [{"addr" => String, "version" => Integer }, {"addr"=> String, "version" => Integer}]}
    }

    begin
      tests("#list_addresses(#{@server_id})").formats(address_format) do
         @service.list_addresses(@server_id).body
      end

      tests("#list_addresses_by_network(#{@server_id}, 'private')").formats(address_format["addresses"].reject {|k,v| k != "private"}) do
        @service.list_addresses_by_network(@server_id, "private").body
      end
    ensure
      @server.destroy if @server
    end

  end

  tests('failure') do
    tests('#list_addresses(0)').raises(Fog::Compute::RackspaceV2::NotFound) do
       @service.list_addresses(0)
    end
    tests("#list_addresses_by_network(0, 'private')").raises(Fog::Compute::RackspaceV2::NotFound) do
      @service.list_addresses_by_network(0, 'private')
    end

  end

end
