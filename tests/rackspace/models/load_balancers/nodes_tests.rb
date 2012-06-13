Shindo.tests('Fog::Rackspace::LoadBalancers | nodes', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      collection_tests(@lb.nodes, { :address => '1.1.1.2', :port => 80, :condition => 'ENABLED'}, false) do
        @lb.wait_for { ready? }
      end
    end
  end
end
