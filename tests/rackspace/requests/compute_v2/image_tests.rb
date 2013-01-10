Shindo.tests('Fog::Compute::RackspaceV2 | image_tests', ['rackspace']) do

  pending if Fog.mocking?

  IMAGE_FORMAT = {
    'id' => String,
    'name' => String,
    'created' => Fog::Nullable::String,
    'updated' => Fog::Nullable::String,
    'status' => Fog::Nullable::String,
    'user_id' => Fog::Nullable::String,
    'tenant_id' => Fog::Nullable::String,
    'progress' => Fog::Nullable::Integer,
    'minDisk' => Fog::Nullable::Integer,
    'minRam' => Fog::Nullable::Integer,
    'metadata' => Fog::Nullable::Hash,
    'OS-DCF:diskConfig' => Fog::Nullable::String,
    'links' => [{
      'rel' => String,
      'href' => String,
      'type' => Fog::Nullable::String
    }]
  }

  LIST_IMAGE_FORMAT = {
    'images' => [IMAGE_FORMAT]
  }

  GET_IMAGE_FORMAT = {
    'image' => IMAGE_FORMAT
  }

  begin
    service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
    test_time = Time.now.to_i.to_s
    @server = service.servers.create(:name => "fog-image-tests_#{test_time}", :flavor_id => 2, :image_id => "3afe97b2-26dc-49c5-a2cc-a2fc8d80c001")
    @server.wait_for { ready? }
    @image_id = nil

    tests('success') do

      tests("#create_image(#{@server.id}, 'fog-test-image')").succeeds do
        response = service.create_image(@server.id, "fog-test-image_#{test_time}")
        @image_id = response.headers["Location"].match(/\/([^\/]+$)/)[1]
      end

      tests('#list_images').formats(LIST_IMAGE_FORMAT) do
        service.list_images.body
      end
      
      tests('#get_image').formats(GET_IMAGE_FORMAT, false) do
        service.get_image(@image_id).body
      end
      
      tests('#delete_image').succeeds do
        service.delete_image(@image_id)
      end
    end
    
    tests('failure') do
      tests('#delete_image').raises(Excon::Errors::BadRequest) do
        pending if Fog.mocking?        
        Fog::Compute[:rackspace].delete_image(0)
      end

      tests('#get_image').raises(Fog::Compute::RackspaceV2::NotFound) do
        pending if Fog.mocking?
        service.get_image(0)
      end
    end
  ensure 
    @image.destroy if @image
    @server.destroy if @server    
  end
end
