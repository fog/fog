
# Shortcut for Fog::Compute[:digitalocean]
def service
  Fog::Compute[:digitalocean]
end

# Create a long lived server for the tests
def fog_test_server
  server = service.servers.find { |s| s.name == 'fog-test-server' }
  unless server
    image = service.images.find { |i| i.name == 'Ubuntu 12.04 x64 Server' }
    region = service.regions.find { |r| r.name == 'New York 1' }
    flavor = service.flavors.find { |r| r.name == '512MB' }
    server = service.servers.create :name      => 'fog-test-server',
                                    :image_id  => image.id,
                                    :region_id => region.id,
                                    :flavor_id => flavor.id
    # Wait for the server to come up
    begin
      server.wait_for(120) { server.reload rescue nil; server.ready? }
    rescue Fog::Errors::TimeoutError
      # Server bootstrap took more than 120 secs!
    end
  end
  server
end

# Destroy the long lived server
def fog_test_server_destroy
  server = service.servers.find { |s| s.name == 'fog-test-server' }
  server.destroy if server
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:digitalocean_api_key].nil?
    server = service.servers.find { |s| s.name == 'fog-test-server' }
    if server
      server.wait_for(120) do
        reload rescue nil; ready?
      end
    end
    fog_test_server_destroy
  end
end
