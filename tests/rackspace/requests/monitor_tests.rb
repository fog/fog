Shindo.tests('Fog::Rackspace::LoadBalancer | monitor', ['rackspace']) do

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
    tests("#get_monitor(#{@lb.id})").formats(HEALTH_MONITOR_FORMAT) do
      @service.get_monitor(@lb.id).body
    end

    @lb.wait_for { ready? }
    tests("#set_monitor(#{@lb.id}, 'CONNECT', 5, 5, 5)").succeeds do
      @service.set_monitor(@lb.id, 'CONNECT', 5, 5, 5)
    end

    @lb.wait_for { ready? }
    tests("#set_monitor(#{@lb.id}, 'HTTP', 5, 5, 5, :path => '/', :body_regex => '^200$', :status_regex => '^2[0-9][0-9]$')").succeeds do
      @service.set_monitor(@lb.id, 'HTTP', 5, 5, 5, :path => '/', :body_regex => '^200$', :status_regex => '2[0-9][0-9]$')
    end

    @lb.wait_for { ready? }
    tests("#get_monitor(#{@lb.id})").formats(HEALTH_MONITOR_FORMAT) do
      @service.get_monitor(@lb.id).body
    end

    @lb.wait_for { ready? }
    tests("#remove_monitor()").succeeds do
      @service.remove_monitor(@lb.id)
    end
  end

  tests('failure') do
    tests("#set_monitor(#{@lb.id}, 'HTP', 5, 5, 5, 5)").raises(Fog::Rackspace::LoadBalancer::BadRequest) do
      @service.set_monitor(@lb.id, 5, 5, 5, 5)
    end

    tests("#remove_monitor(#{@lb.id}) => No Monitor").raises(Fog::Rackspace::LoadBalancer::ServiceError) do
      @service.remove_monitor(@lb.id)
    end
  end

  @lb.wait_for { ready? }
  @lb.destroy
end
