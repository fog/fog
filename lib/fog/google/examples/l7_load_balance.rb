require 'rubygems'
require 'fog'

def test
  connection = Fog::Compute.new({:provider => "google"})

  health = connection.http_health_checks.create({
    :name => 'test-checks'
    })
  backend= connection.backend_services.create({
    :name => 'backend-test',
    :health_checks => [health.self_link],
    :port => 8080,
    :timeout_sec => 40,
    :backends => [{'group' => 'resource view self link'}]
    })
  backend = connection.backend_services.get('backend-test')
  url = connection.url_maps.create({
     :name => 'map',
     :defaultService => backend.self_link,
    :hostRules => [ {'hosts' => ['google.com'], 'pathMatcher' => 'pathmap'}],
    :pathMatchers => [{'name' => 'pathmap', 'defaultService' => backend.self_link, 'pathRules' => [{ 'paths' => ['/videos','/videos/*'], 'service' => backend.self_link}]}],
     :tests => [{'host' => 'myhost.com', 'service' => backend.self_link }] 
     })
  proxy = connection.target_http_proxies.create({
    :name => 'something',
    :urlMap => url.self_link
    }) 
end
test
