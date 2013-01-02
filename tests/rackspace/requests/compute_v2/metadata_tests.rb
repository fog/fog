Shindo.tests('Fog::Compute::RackspaceV2 | metadata_tests', ['rackspace']) do
  
  @service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  
  tests('success') do
    begin
      metadata = {"Tag" => "Database"}
      
      unless Fog.mocking?
        @server = @service.servers.create(:name => "fog-server-metadata-#{Time.now.to_i}", 
                                          :flavor_id => 2,
                                          :image_id => '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001',
                                          :metadata => {"Tag" => "Database"})
        @server.wait_for(timeout = 1200) { ready? }
      end
      tests('list_server_metadata').returns("metadata" => metadata) do
        @service.list_server_metadata(@server.id).body
      end
      tests('set_server_metadata').returns("metadata" => {"environment" => "dev"}) do
        @service.set_server_metadata(@server.id, {"environment" => "dev"}).body
      end
      tests('update_server_metadata').returns("metadata" => {"environment" => "dev", "Tag" => "Database"}) do
        @service.update_server_metadata(@server.id, {"environment" => "dev", "Tag" => "Database"}).body
      end
      tests('get_server_metadata_item').returns("meta" => {"environment" => "dev"}) do
        @service.get_server_metadata_item(@server.id, "environment").body
      end
      tests('set_server_metadata_item').returns("meta" => {"environment", "test"}) do
        @service.set_server_metadata_item(@server.id, "environment", "test").body
      end
      tests('delete_server_metadata_item').succeeds do
        @service.delete_server_metadata_item(@server.id, "environment").body
      end
    ensure
      @server.destroy if @server
    end
  end

  tests('failure') do
    tests('list_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
      @service.list_server_metadata(0)
    end
    tests('set_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
      @service.set_server_metadata(0, {"environment" => "dev"})
    end
    tests('update_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
      @service.update_server_metadata(0, {"environment" => "dev", "Tag" => "Database"})
    end
    tests('get_server_metadata_item').raises(Fog::Compute::RackspaceV2::NotFound)  do
      @service.get_server_metadata_item(0, "environment")
    end
    tests('set_server_metadata_item').raises(Fog::Compute::RackspaceV2::NotFound) do
      @service.set_server_metadata_item(0, "environment", "test")      
    end
    tests('delete_server_metadata_item').raises(Fog::Compute::RackspaceV2::NotFound)  do
      @service.delete_server_metadata_item(0, "environment")      
    end
  end
end


