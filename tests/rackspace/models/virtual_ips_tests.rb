Shindo.tests('Fog::Rackspace::LoadBalancers | virtual_ips', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      collection_tests(@lb.virtual_ips, { :type => 'PUBLIC'}, false) do
        @lb.wait_for { ready? }
      end
    end
  end
end
