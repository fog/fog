Shindo.tests('Fog::Rackspace::LoadBalancer | usage', ['rackspace']) do

  given_a_load_balancer_service do
    tests('success') do

      tests("#get_usage()").formats(USAGE_FORMAT) do
        @service.get_usage.body
      end

      tests("#get_usage(:start_time => '2010-05-10', :end_time => '2010-05-11')").formats(USAGE_FORMAT) do
        @service.get_usage(:start_time => '2010-05-10', :end_time => '2010-05-11').body
      end
    end
  end
end
