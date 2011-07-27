Shindo.tests('Fog::Rackspace::LoadBalancer | session_persistence', ['rackspace']) do

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
    tests("#set_session_persistence(#{@lb.id}, 'aaa')").raises(Fog::Rackspace::LoadBalancer::BadRequest) do
      @service.set_session_persistence(@lb.id, 'aaa')
    end
  end

  @lb.wait_for { ready? }
  @lb.destroy
end
