Shindo.tests('Fog::Rackspace::LoadBalancer | nodes', ['rackspace']) do

  given_a_load_balancer_service do
    given_a_load_balancer do
      collection_tests(@lb.nodes, { :address => '10.0.0.2', :port => 80, :condition => 'ENABLED'}, false) do
        @lb.wait_for { ready? }
      end
    end
  end
end
