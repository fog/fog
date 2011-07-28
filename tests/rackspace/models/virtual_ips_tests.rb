Shindo.tests('Fog::Rackspace::LoadBalancer | virtual_ips', ['rackspace']) do

  given_a_load_balancer_service do
    given_a_load_balancer do
      collection_tests(@lb.virtual_ips, { :type => 'PUBLIC'}, false) do
        @lb.wait_for { ready? }
      end
    end
  end
end
