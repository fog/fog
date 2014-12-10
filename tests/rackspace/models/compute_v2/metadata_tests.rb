Shindo.tests('Fog::Compute::RackspaceV2 | metadata', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Compute::RackspaceV2.new
  test_time = Time.now.to_i.to_s

  tests('success') do
    begin
      @server = service.servers.create(:name => "fog_server_#{test_time}",
      :flavor_id => rackspace_test_flavor_id(service),
      :image_id => rackspace_test_image_id(service))

      @server.wait_for { ready? }

      tests('server') do
        collection_tests(@server.metadata, {:key => 'my_key', :value => 'my_value'}) do
          @server.wait_for { ready? }
        end
      end

      tests('image') do
        @image = @server.create_image("fog_image_#{test_time}", :metadata => {:my_key => 'my_value'})
        @image.wait_for { ready? }
        tests("#all").succeeds do
          pending if Fog.mocking? && !mocks_implemented
          metadata = @image.metadata.all
          my_metadata = metadata.select {|datum| datum.key == 'my_key'}
          returns(1) { my_metadata.size }
          returns('my_value') {my_metadata[0].value }
        end

        tests("#get('my_key')").returns('my_value') do
          pending if Fog.mocking? && !mocks_implemented
          @image.metadata.get('my_key').value
        end
      end

    ensure
      @image.destroy if @image
      @server.destroy if @server
    end
  end
end
