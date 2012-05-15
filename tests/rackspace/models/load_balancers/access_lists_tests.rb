Shindo.tests('Fog::Rackspace::LoadBalancers | access_lists', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      collection_tests(@lb.access_rules, { :address => '1.1.1.2', :type => 'ALLOW'}, false) do
        @lb.wait_for { ready? }
      end
    end
  end
end
