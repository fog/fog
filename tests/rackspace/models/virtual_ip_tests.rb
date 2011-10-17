Shindo.tests('Fog::Rackspace::LoadBalancers | virtual_ip', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      model_tests(@lb.virtual_ips, { :type => 'PUBLIC'}, false) do
        @lb.wait_for { ready? }

        tests("#save => existing virtual IP").raises(Fog::Errors::Error) do
          @instance.save
        end
      end
    end
  end
end
