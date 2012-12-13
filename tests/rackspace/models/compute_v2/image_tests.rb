Shindo.tests('Fog::Compute::RackspaceV2 | image', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Compute::RackspaceV2.new
  test_time = Time.now.to_i.to_s
  options = {
    :name => "fog_server_#{test_time}",
    :flavor_id => 2,
    :image_id => '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001'
  }
  

  tests("success") do
    begin
      server = service.servers.create(options)
      server.wait_for { ready? }
      image_id = server.create_image("fog_image_#{test_time}")
      image = service.images.get(image_id)        
    
      tests("destroy").succeeds do
        image.destroy
      end
    ensure
      server.destroy if server
    end
  end  
end
