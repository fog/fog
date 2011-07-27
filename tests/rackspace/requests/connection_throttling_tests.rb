Shindo.tests('Fog::Rackspace::LoadBalancer | connection_throttling', ['rackspace']) do

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
    tests("#set_connection_throttling(#{@lb.id}, -1, -1, -1, -1)").raises(Fog::Rackspace::LoadBalancer::BadRequest) do
      @service.set_connection_throttling(@lb.id, -1, -1, -1, -1)
    end
  end

  @lb.wait_for { ready? }
  @lb.destroy
end
