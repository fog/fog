Shindo.tests('Fog::Rackspace::LoadBalancer | load_balancer_usage', ['rackspace']) do

  @service = Fog::Rackspace::LoadBalancer.new
  @lb = @service.load_balancers.create({
      :name => ('fog' + Time.now.to_i.to_s),
      :protocol => 'HTTP',
      :port => 80,
      :virtual_ips => [{ :type => 'PUBLIC'}],
      :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
    })

  tests('success') do
    @lb.wait_for { ready? }
    tests("#get_usage(#{@lb.id})").formats(LOAD_BALANCER_USAGE_FORMAT) do
      @service.get_load_balancer_usage(@lb.id).body
    end

    tests("#get_usage(:start_time => '2010-05-10', :end_time => '2010-05-11')").formats(LOAD_BALANCER_USAGE_FORMAT) do
      @service.get_load_balancer_usage(@lb.id, :start_time => '2010-05-10', :end_time => '2010-05-11').body
    end
  end

  @lb.wait_for { ready? }
  @lb.destroy
end
