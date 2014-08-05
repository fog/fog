Shindo.tests('Fog::Compute::RackspaceV2 | metadata_tests', ['rackspace']) do

  @service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  image_id  = rackspace_test_image_id(@service)
  flavor_id = rackspace_test_flavor_id(@service)

  tests('success') do
    begin
      metadata = {"tag" => "database"}

      unless Fog.mocking?
        name = "fog-server-metadata-#{Time.now.to_i}"
        @server = @service.servers.create(:name => name,
                                          :flavor_id => flavor_id,
                                          :image_id => image_id,
                                          :metadata => metadata)
        @server.wait_for { ready? }


        @server_id = @server.id
        @image  = @server.create_image(name, :metadata => metadata)
        @image_id = @image.id
      else
        @image_id = 1
        @server_id = 1
      end

        tests("servers") do
          tests('list_metadata').returns("metadata" => metadata) do
            @service.list_metadata("servers", @server_id).body
          end
          tests('set_metadata').returns("metadata" => {"environment" => "dev"}) do
            @service.set_metadata("servers", @server_id, {"environment" => "dev"}).body
          end
          tests('update_metadata').returns("metadata" => {"environment" => "dev", "tag" => "database"}) do
            @service.update_metadata("servers", @server_id, {"environment" => "dev", "tag" => "database"}).body
          end
          tests('get_metadata_item').returns("meta" => {"environment" => "dev"}) do
            @service.get_metadata_item("servers", @server_id, "environment").body
          end
          tests('set_metadata_item').returns("meta" => {"environment" => "test"}) do
            @service.set_metadata_item("servers", @server_id, "environment", "test").body
          end
          tests('delete_metadata_item').succeeds do
            @service.delete_metadata_item("servers", @server_id, "environment")
          end
        end

        tests("images") do
          @image.wait_for { ready? } unless Fog.mocking?

          tests('list_metadata').returns(metadata) do
            h = @service.list_metadata("images", @image_id).body
            h["metadata"].reject {|k,v| k.downcase != "tag"} #only look at the metadata we created
          end
          tests('set_metadata').returns({"environment" => "dev"}) do
            h = @service.set_metadata("images", @image_id, {"environment" => "dev"}).body
            h["metadata"].reject {|k,v| k.downcase != "environment"} #only look at the metadata we created
          end
          tests('update_metadata').returns({"environment" => "dev", "tag" => "database"}) do
            h = @service.update_metadata("images", @image_id, {"environment" => "dev", "tag" => "database"}).body
            h["metadata"].reject {|k,v| !['environment', 'tag'].include?(k.downcase)} #only look at the metadata we created
          end
          tests('get_metadata_item').returns("meta" => {"environment" => "dev"}) do
            @service.get_metadata_item("images", @image_id, "environment").body
          end
          tests('set_metadata_item').returns("meta" => {"environment" => "test"}) do
            @service.set_metadata_item("images", @image_id, "environment", "test").body
          end
          tests('delete_metadata_item').succeeds do
            @service.delete_metadata_item("images", @image_id, "environment")
          end
        end
    ensure
      @image.destroy if @image
      @server.destroy if @server
    end
  end

  tests('failure') do
    ['server', 'image'].each do |collection|
      tests(collection) do
        tests('list_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.list_metadata(collection, 0)
        end
        tests('set_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.set_metadata(collection, 0, {"environment" => "dev"})
        end
        tests('update_server_metadata').raises(Fog::Compute::RackspaceV2::NotFound)  do
          @service.update_metadata(collection, 0, {"environment" => "dev", "tag" => "database"})
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
