Shindo.tests('Fog::Rackspace::LoadBalancers | content_caching', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do
        tests("#get_content_caching(#{@lb.id})").formats(CONTENT_CACHING_FORMAT) do
          @service.get_content_caching(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#set_content_caching(#{@lb.id}, true)").succeeds do
          @service.set_content_caching(@lb.id, true)
        end
      end

      tests('failure') do
        tests("#set_content_caching(#{@lb.id}, 'aaa')").raises(Fog::Rackspace::LoadBalancers::InternalServerError) do
          @service.set_content_caching(@lb.id, 'aaa')
        end
      end
    end
  end
end
