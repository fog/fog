Shindo.tests("Fog::Compute[:google] | backend_services model", ['google']) do
  
  @health_check = create_test_http_health_check(Fog::Compute[:google])
  collection_tests(Fog::Compute[:google].backend_services, {:name => 'fog-backend-services-test', 
      :health_checks => [@health_check]})

end
