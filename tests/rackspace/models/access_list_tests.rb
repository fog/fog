Shindo.tests('Fog::Rackspace::LoadBalancer | access_list', ['rackspace']) do

  given_a_load_balancer_service do
    given_a_load_balancer do
      model_tests(@lb.access_rules, { :address => '10.0.0.2', :type => 'ALLOW'}, false) do
        @lb.wait_for { ready? }
      end
    end
  end
end
