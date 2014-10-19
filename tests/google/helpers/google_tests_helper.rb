require 'securerandom'

# create a disk to be used in tests
def create_test_disk(connection, zone)
  zone = 'us-central1-a'
  random_string = SecureRandom.hex

  disk = connection.disks.create({
    :name => "fog-test-disk-#{random_string}",
    :size_gb => "10",
    :zone => zone,
    :source_image => "debian-7-wheezy-v20140408",
  })
  disk.wait_for { ready? }
  disk
end

def create_test_http_health_check(connection)
  random_string = SecureRandom.hex
  health_check = connection.http_health_checks.create({
      :name => "fog-test-check-#{random_string}"
      })
  health_check
end

def create_test_backend_service(connection)
  random_string = SecureRandom.hex
  health_check = create_test_http_health_check(connection)
  backend_service = connection.backend_services.create({
      :name => "fog-test-backend-service-#{random_string}",
      :health_checks => [health_check]
      })
end

def create_test_url_map(connection)
  random_string = SecureRandom.hex
  backend_service = create_test_backend_service(connection)
  url_map = connection.url_maps.create({
      :name => "fog-test-url-map-#{random_string}",
      :defaultService => backend_service.self_link
      })
end

def create_test_server(connection, zone)
  random_string = SecureRandom.hex
  disk = create_test_disk(connection,zone)
  server = connection.servers.create({
      :name => "fog-test-server-#{random_string}",
      :disks => [disk],
      :zone => zone,
      :machine_type => 'n1-standard-1'
      })
end

def create_test_target_http_proxy(connection)
  random_string = SecureRandom.hex
  url_map = create_test_url_map(connection)
  proxy = connection.target_http_proxies.create({
      :name => "fog-test-target-http-proxy-#{random_string}",
      :urlMap => url_map.self_link
      })
end

def create_test_zone_view(connection, zone)
  random_string = SecureRandom.hex
  zone_view = connection.zone_views.create({
      :name => "fog-test-zone-view-#{random_string}",
      :zone => zone
      })
  zone_view.wait_for {ready?}
  zone_view
end

def create_test_target_pool(connection, region)
  random_string = SecureRandom.hex
  http_health_check = create_test_http_health_check(connection)
  instance = create_test_server(connection, 'us-central1-a')
  target_pool = connection.target_pools.create({
      :name => "fog-test-target-pool-#{random_string}",
      :region => region,
      :healthChecks => [http_health_check.self_link],
      :instances => [instance.self_link]\
      })
end

def wait_operation(connection, response)
  operation = connection.operations.get(response['name'], response['zone'], response['region'])
  operation.wait_for { ready? }
end
