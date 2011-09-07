Shindo.tests('Fog::Rackspace::LoadBalancers | load_balancer_usage', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do
        @lb.wait_for { ready? }
        tests("#get_usage(#{@lb.id})").formats(LOAD_BALANCER_USAGE_FORMAT) do
          @service.get_load_balancer_usage(@lb.id).body
        end

        tests("#get_usage(:start_time => '2010-05-10', :end_time => '2010-05-11')").formats(LOAD_BALANCER_USAGE_FORMAT) do
          @service.get_load_balancer_usage(@lb.id, :start_time => '2010-05-10', :end_time => '2010-05-11').body
        end
      end
    end
  end
end
