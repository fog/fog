Shindo.tests('Fog::Rackspace::LoadBalancer | connection_logging', ['rackspace']) do

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do
        tests("#get_connection_logging(#{@lb.id})").formats(CONNECTION_LOGGING_FORMAT) do
          @service.get_connection_logging(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#set_connection_logging(#{@lb.id}, true)").succeeds do
          @service.set_connection_logging(@lb.id, true)
        end
      end

      tests('failure') do
        tests("#set_connection_logging(#{@lb.id}, 'aaa')").raises(Fog::Rackspace::LoadBalancer::InternalServerError) do
          @service.set_connection_logging(@lb.id, 'aaa')
        end
      end
    end
  end
end
