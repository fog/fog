Shindo.tests('Fog::Rackspace::LoadBalancers | connection_throttling', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do

        @lb.wait_for { ready? }
        tests("#get_connection_throttling(#{@lb.id})").formats(CONNECTION_THROTTLING_FORMAT) do
          @service.get_connection_throttling(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#set_connection_throttling(#{@lb.id}, 10, 10, 10, 30)").succeeds do
          @service.set_connection_throttling(@lb.id, 10, 10, 10, 30)
        end

        @lb.wait_for { ready? }
        tests("#get_connection_throttling(#{@lb.id})").formats(CONNECTION_THROTTLING_FORMAT) do
          @service.get_connection_throttling(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#remove_connection_throttling()").succeeds do
          @service.remove_connection_throttling(@lb.id)
        end
      end

      tests('failure') do
        tests("#set_connection_throttling(#{@lb.id}, -1, -1, -1, -1)").raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.set_connection_throttling(@lb.id, -1, -1, -1, -1)
        end
      end
    end
  end
end
