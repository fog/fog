Shindo.tests('Fog::Rackspace::LoadBalancers | node', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      model_tests(@lb.nodes, { :address => '10.0.0.2', :port => 80, :condition => 'ENABLED'}, false) do
        @lb.wait_for { ready? }

        tests("#save() => existing node with port = 88").succeeds do
          @instance.port = 88
          @instance.save
        end

        @lb.wait_for { ready? }
      end
    end
  end
end
