# This example assumes three instances have been created in the project.
# They should each have Apache installed and distinct index.html files
# in order to observe the results of the l7 load balancer. A firewall
# rule should also have been created with a tag shared by the instances.
# More info on Google's HTTP load balancing: 
# https://developers.google.com/compute/docs/load-balancing/http/

def test
  connection = Fog::Compute.new({:provider => "google"})
  health = connection.http_health_checks.create({
    :name => 'test-checks'
    })
  instance1 = connection.servers.get('fog-l7-instance-1')
  instance2 = connection.servers.get('fog-l7-instance-2')
  instance3  = connection.servers.get('fog-l7-instance-3')

  resource_view1 = connection.resource_views.create({ 
    :name => 'fog-l7-resource-view-1',
    :numMembers => 1, 
    :members => [instance1.self_link], 
    :zone => 'us-central1-a' 
    })
  resource_view1.add_resources(instance1.self_link)
  resource_view2 = connection.resource_views.create({ 
    :name => 'fog-l7-resource-view-2', 
    :numMembers => 1, 
    :members => [instance2.self_link], 
    :zone => 'us-central1-a' 
    })
  resource_view2.add_resources(instance2.self_link)
  resource_view3 = connection.resource_views.create({ 
    :name => 'fog-l7-resource-view-3', 
    :members => [instance3.self_link], 
    :zone => 'us-central1-b' })
  resource_view3.add_resources(instance3.self_link)
  backend_service1 = connection.backend_services.create({
    :name => 'fog-l7-backend-service-1',
    :health_checks => [health.self_link],
    :backends => [{'balancingMode' => 'RATE', 'maxRate' => 100, 'group' => resource_view1.self_link}]
  })
  backend_service2 = connection.backend_services.create({
    :name => 'fog-l7-backend-service-2',
    :health_checks => [health.self_link],
    :backends => [{'balancingMode' => 'RATE', 'maxRate' => 100, 'group' => resource_view2.self_link}]
  })
  backend_service3 = connection.backend_services.create({
    :name => 'fog-l7-backend-service-3',
    :health_checks => [health.self_link],
    :backends => [{'balancingMode' => 'RATE', 'maxRate' => 100, 'group' => resource_view3.self_link}]
  })
  url_map = connection.url_maps.create({
    :name => 'fog-l7-url-map',
    :pathMatchers => [{ 
      'name' => 'pathmatcher', 
      'defaultService' => backend_service1.self_link, 
      'pathRules' => [
        { 'paths' => ["/one/*"], 
        "service" => backend_service1.self_link }, 
        {'paths' => ["/two/*"], 
        "service" => backend_service2.self_link }, 
        {'paths' => ["/three/*"], 
        'service' => backend_service3.self_link } 
        ]
      }], 
    :hostRules => [{ 'hosts' => ['*'], 'pathMatcher' => 'pathmatcher'}],
    :defaultService => backend_service1.self_link,
  })
  proxy = connection.target_http_proxies.create({
    :name => 'fog-l7-proxy',
    :urlMap => url_map.self_link
  }) 
  fwd_rle = connection.global_forwarding_rules.create({:name => 'fog-l7-fwd-rule', :target => proxy.self_link })
end
