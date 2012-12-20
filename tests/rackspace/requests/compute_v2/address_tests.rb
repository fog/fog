Shindo.tests('Fog::Compute::RackspaceV2 | address requests', ['rackspace']) do

  @service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  
  tests('success') do
    unless Fog.mocking?
      @server = @service.servers.create(:flavor_id => 2, :image_id => "8a3a9f96-b997-46fd-b7a8-a9e740796ffd", :name => "address-tests-#{Time.now.to_i}")
      @server.wait_for(timeout=1200) { ready? }
    end
    
    address_format =  { "addresses"=> { 
      "private" => [{"addr" => String, "version" => Integer}], 
      "public" => [{"addr" => String, "version" => Integer }, {"addr"=> String, "version" => Integer}]}
      }

    begin 
      tests("#list_addresses(#{@server.id})").formats(address_format) do
         @service.list_addresses(@server.id).body
      end
    ensure
      @server.destroy if @server
    end

  end

  tests('failure') do
    tests('#list_addresses(0)').raises(Fog::Compute::RackspaceV2::NotFound) do
       @service.list_addresses(0)
    end

  end

end
