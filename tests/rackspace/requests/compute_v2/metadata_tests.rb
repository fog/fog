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
      [['server', @server.id]].each do |params|
        collection = params[0]
        id = params[1]
        tests(collection) do
          tests('list_metadata').returns("metadata" => metadata) do
            @service.list_metadata(collection, id).body
          end
          tests('set_metadata').returns("metadata" => {"environment" => "dev"}) do
            @service.set_metadata(collection, id, {"environment" => "dev"}).body
          end
          tests('update_metadata').returns("metadata" => {"environment" => "dev", "Tag" => "Database"}) do
            @service.update_metadata(collection, id, {"environment" => "dev", "Tag" => "Database"}).body
          end
          tests('get_metadata_item').returns("meta" => {"environment" => "dev"}) do
            @service.get_metadata_item(collection, id, "environment").body
          end
          tests('set_metadata_item').returns("meta" => {"environment", "test"}) do
            @service.set_metadata_item(collection, id, "environment", "test").body
          end
          tests('delete_metadata_item').succeeds do
            @service.delete_metadata_item(collection, id, "environment").body
          end
        end
      end
    ensure
      @server.destroy if @server
    end
  end

  tests('failure') do
    ['server'].each do |collection|
      tests(collection) do
        tests('list_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.list_metadata(collection, 0)
        end
        tests('set_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.set_metadata(collection, 0, {"environment" => "dev"})
        end
        tests('update_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.update_metadata(collection, 0, {"environment" => "dev", "Tag" => "Database"})
        end
        tests('get_server_metadata_item').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.get_metadata_item(collection, 0, "environment")
        end
        tests('set_server_metadata_item').raises(Fog::Compute::RackspaceV2::NotFound) do
          @service.set_metadata_item(collection, 0, "environment", "test")      
        end
        tests('delete_server_metadata_item').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.delete_metadata_item(collection, 0, "environment")      
        end
      end
    end
  end
end


