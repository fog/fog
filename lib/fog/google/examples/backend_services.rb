require 'rubygems'
require 'fog'

def test
  connection = Fog::Compute.new({:provider => "google"})
  health = connection.http_health_checks.create({
    :name => 'test-checks'
  })
  health.wait_for { health.ready? }
  backend= connection.backend_services.create({
    :name => 'backend-test',
    :health_checks => [health.self_link],
    :port => 8080,
    :timeout_sec => 40,
    :backends => [{'group' => 'resource_view self_link'}]
  })
  puts connection.backend_services.all
  backend= connection.backend_services.get('backend-test')
  backend.get_health
end

test
