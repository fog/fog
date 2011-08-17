Shindo.tests('Fog::Rackspace::LoadBalancers | session_persistence', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do
        @lb.wait_for { ready? }
        tests("#set_session_persistence(#{@lb.id}, 'HTTP_COOKIE')").succeeds do
          @service.set_session_persistence(@lb.id, 'HTTP_COOKIE')
        end

        @lb.wait_for { ready? }
        tests("#get_session_persistence{@lb.id})").formats(SESSION_PERSISTENCE_FORMAT) do
          data = @service.get_session_persistence(@lb.id).body
          returns('HTTP_COOKIE') { data['sessionPersistence']['persistenceType'] }
          data
        end

        @lb.wait_for { ready? }
        tests("#remove_session_persistence()").succeeds do
          @service.remove_session_persistence(@lb.id)
        end
      end

      tests('failure') do
        tests("#set_session_persistence(#{@lb.id}, 'aaa')").raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.set_session_persistence(@lb.id, 'aaa')
        end
      end
    end
  end
end
