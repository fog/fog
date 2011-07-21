Shindo.tests('Fog::Rackspace::LoadBalancer | load_balancer', ['rackspace']) do

  LOAD_BALANCER_ATTRIBUTES = {
      :name => 'fog' + Time.now.to_i.to_s,
      :protocol => 'HTTP',
      :port => 80,
      :virtual_ips => [{ :type => 'PUBLIC'}],
      :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
    }

  @service = Fog::Rackspace::LoadBalancer.new

  model_tests(@service.load_balancers, LOAD_BALANCER_ATTRIBUTES, false) do

    @instance.wait_for { ready? }
    tests('#save => saving existing with port = 88').succeeds do
      @instance.port = 88
      @instance.save
    end

    @instance.wait_for { ready? }
    tests('#enable_connection_logging').succeeds do
      @instance.enable_connection_logging
      returns(true) { @instance.connection_logging }
    end

    @instance.wait_for { ready? }
    tests('#disable_connection_logging').succeeds do
      @instance.disable_connection_logging
      returns(false) { @instance.connection_logging }
    end

    @instance.wait_for { ready? }
  end
end
