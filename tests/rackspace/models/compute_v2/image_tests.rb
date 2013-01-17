Shindo.tests('Fog::Compute::RackspaceV2 | image', ['rackspace']) do
  service    = Fog::Compute::RackspaceV2.new
  flavor_id  = Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id
  image_id   = Fog.credentials[:rackspace_image_id]  || service.images.first.id

  test_time = Time.now.to_i.to_s
  options = {
    :name => "fog_server_#{test_time}",
    :flavor_id => flavor_id,
    :image_id => image_id
  }

  tests("success") do
    begin
      server = service.servers.create(options)
      server.wait_for { ready? }
      image = server.create_image("fog_image_#{test_time}")

      tests("destroy").succeeds do
        image.destroy
      end
    ensure
      server.destroy if server
    end
  end
end
