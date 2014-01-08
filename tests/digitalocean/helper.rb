
# Shortcut for Fog::Compute[:digitalocean]
def service
  Fog::Compute[:digitalocean]
end

def fog_test_server_attributes
  # Hard coding numbers because requests from tests are sometimes failing.
  # TODO: Mock properly instead
  image = service.images.find { |i| i.name == 'Ubuntu 13.10 x64' }
  image_id = image.nil? ? 1505447 : image.id
  region = service.regions.find { |r| r.name == 'New York 1' }
  region_id = region.nil? ? 4 : region.id
  flavor = service.flavors.find { |r| r.name == '512MB' }
  flavor_id = flavor.nil? ? 66 : flavor.id

  {
    :image_id  => image_id,
    :region_id => region_id,
    :flavor_id => flavor_id
  }
end

def fog_server_name
  "fog-server-test"
end

# Create a long lived server for the tests
def fog_test_server
  server = service.servers.find { |s| s.name == fog_server_name }
  unless server
    server = service.servers.create({
      :name => fog_server_name
    }.merge(fog_test_server_attributes))
    server.wait_for { ready? }
  end
  server
end

# Destroy the long lived server
def fog_test_server_destroy
  server = service.servers.find { |s| s.name == fog_server_name }
  server.destroy if server
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:digitalocean_api_key].nil?
    server = service.servers.find { |s| s.name == fog_server_name }
    if server
      server.wait_for(120) do
        reload rescue nil; ready?
      end
    end
    fog_test_server_destroy
  end
end
