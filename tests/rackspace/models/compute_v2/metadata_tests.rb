Shindo.tests('Fog::Compute::RackspaceV2 | metadata', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Compute::RackspaceV2.new
  test_time = Time.now.to_i.to_s
  
  tests('success') do
    begin
      @server = service.servers.create(:name => "fog_server_#{test_time}", :flavor_id => 2, :image_id => "3afe97b2-26dc-49c5-a2cc-a2fc8d80c001")
      @server.wait_for(timeout=1500) { ready? }
      @server = service.servers.get "2ee0e1b5-3350-40ae-873a-fff4941cc400"
      
      tests('server') do
        collection_tests(@server.metadata, {:key => 'my_key', :value => 'my_value'}) do
          @server.wait_for { ready? }
        end
      end
      
      tests('image') do
        image_id = @server.create_image("fog_image_#{test_time}", :metadata => {:my_key => 'my_value'})
        @image = service.images.get image_id
        @image.wait_for(timeout = 1500) { ready? }
        tests("#all").succeeds do
          pending if Fog.mocking? && !mocks_implemented
          @image.metadata.all
        end

        tests("#get('my_key')").succeeds do
          pending if Fog.mocking? && !mocks_implemented
          @image.metadata.get('my_key')
        end        
      end
      
    ensure
      @image.destroy if @image
      @server.destroy if @server
    end
  end
end