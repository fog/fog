Shindo.tests('Fog::Rackspace::LoadBalancers | load_balancer_get_stats', ['rackspace']) do

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do
        @lb.wait_for { ready? }
        tests("#get_stats(#{@lb.id})").formats(LOAD_BALANCER_STATS_FORMAT) do
          @service.get_stats(@lb.id).body
        end
      end
    end
  end
end
