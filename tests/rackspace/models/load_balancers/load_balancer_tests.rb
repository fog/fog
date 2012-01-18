Shindo.tests('Fog::Rackspace::LoadBalancers | load_balancer', ['rackspace']) do

  pending if Fog.mocking?

  LOAD_BALANCER_ATTRIBUTES = {
      :name => 'fog' + Time.now.to_i.to_s,
      :protocol => 'HTTP',
      :port => 80,
      :virtual_ips => [{ :type => 'PUBLIC'}],
      :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
    }

  given_a_load_balancer_service do
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

      tests('#enable_connection_logging after reload').succeeds do
        @instance.reload
        returns(true) { @instance.connection_logging }
      end

      @instance.wait_for { ready? }
      tests('#disable_connection_logging').succeeds do
        @instance.disable_connection_logging
        returns(false) { @instance.connection_logging }
      end

      tests('#usage').succeeds do
        @instance.usage
      end

      tests("#usage(:start_time => '2010-05-10', :end_time => '2010-05-11')").succeeds do
        @instance.usage(:start_time => '2010-05-10', :end_time => '2010-05-11')
      end

      tests("#health_monitor").returns(nil) do
        @instance.health_monitor
      end

      @instance.wait_for { ready? }
      tests("#enable_health_monitor('CONNECT', 5, 5, 5)").succeeds do
        @instance.enable_health_monitor('CONNECT', 5, 5, 5)
      end

      @instance.wait_for { ready? }
      tests("#health_monitor").succeeds do
        monitor = @instance.health_monitor
        returns('CONNECT') { monitor['type'] }
      end

      @instance.wait_for { ready? }
      tests("#enable_health_monitor('HTTP', 10, 5, 2, {:status_regex => '^[234][0-9][0-9]$', :path=>'/', :body_regex=>' '})").succeeds do
        @instance.enable_health_monitor('HTTP', 10, 5, 2, {:status_regex => '^[234][0-9][0-9]$', :path=>'/', :body_regex=>' '})
      end

      @instance.wait_for { ready? }
      tests("#disable_health_monitor").succeeds do
        @instance.disable_health_monitor
      end

      @instance.wait_for { ready? }
      tests("#connection_throttling").returns(nil) do
        @instance.connection_throttling
      end

      tests("#enable_connection_throttling(5, 5, 5, 5)").succeeds do
        @instance.enable_connection_throttling(5, 5, 5, 5)
      end

      @instance.wait_for { ready? }
      tests("#connection_throttling").succeeds do
        throttle = @instance.connection_throttling
        returns(5) { throttle['maxConnections'] }
      end

      @instance.wait_for { ready? }
      tests("#disable_connection_throttling").succeeds do
        @instance.disable_connection_throttling
      end

      @instance.wait_for { ready? }
      tests("#session_persistence").returns(nil) do
        @instance.session_persistence
      end

      tests("#enable_session_persistence('HTTP_COOKIE')").succeeds do
        @instance.enable_session_persistence('HTTP_COOKIE')
      end

      @instance.wait_for { ready? }
      tests("#connction_throttling").succeeds do
        persistence = @instance.session_persistence
        returns('HTTP_COOKIE') { persistence['persistenceType'] }
      end

      @instance.wait_for { ready? }
      tests("#disable_session_persistence").succeeds do
        @instance.disable_session_persistence
      end

      @instance.wait_for { ready? }
      tests("#error_page").succeeds do
        @instance.error_page
      end

      @instance.wait_for { ready? }
      tests("#error_page = 'asdf'").succeeds do
        @instance.error_page = 'asdf'
      end

      @instance.wait_for { ready? }
      tests("#reset_error_page").succeeds do
        @instance.reset_error_page
      end

      @instance.wait_for { ready? }
    end

    tests('failure') do
      @lb = @service.load_balancers.new LOAD_BALANCER_ATTRIBUTES
      tests('#usage => Requires ID').raises(ArgumentError) do
        @lb.usage
      end

      tests('#health_monitor => Requires ID').raises(ArgumentError) do
        @lb.health_monitor
      end
    end
  end
end
