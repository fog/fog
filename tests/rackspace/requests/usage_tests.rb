Shindo.tests('Fog::Rackspace::LoadBalancer | usage', ['rackspace']) do

  @service = Fog::Rackspace::LoadBalancer.new

  tests('success') do

    tests("#get_usage()").formats(USAGE_FORMAT) do
      @service.get_usage.body
    end

    tests("#get_usage(:start_time => '2010-05-10', :end_time => '2010-05-11')").formats(USAGE_FORMAT) do
      @service.get_usage(:start_time => '2010-05-10', :end_time => '2010-05-11').body
    end
  end
end
