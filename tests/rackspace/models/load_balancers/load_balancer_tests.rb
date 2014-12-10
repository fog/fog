Shindo.tests('Fog::Rackspace::LoadBalancers | load_balancer', ['rackspace']) do

  pending if Fog.mocking?

  MINIMAL_LB_ATTRIBUTES = {
    :name => "fog#{Time.now.to_i}",
    :protocol => 'HTTP',
    :virtual_ips => [{ :type => 'PUBLIC' }],
  }

  NORMAL_LB_ATTRIBUTES = MINIMAL_LB_ATTRIBUTES.merge({
    :port => 8080,
    :nodes => [{ :address => '1.1.1.1', :port => 80, :condition => 'ENABLED' }]
  })

  FULL_LB_ATTRIBUTES = NORMAL_LB_ATTRIBUTES.merge({
    :algorithm => 'LEAST_CONNECTIONS',
    :timeout => 60
  })

  HTTPS_REDIRECT_LB_ATTRIBUTES = FULL_LB_ATTRIBUTES.merge({
    :protocol => 'HTTPS',
    :https_redirect => true
  })

  given_a_load_balancer_service do
    model_tests(@service.load_balancers, NORMAL_LB_ATTRIBUTES, false) do

      @instance.wait_for { ready? }
      tests('#save => saving existing with port = 88').succeeds do
        @instance.port = 88
        @instance.save
      end

      @instance.wait_for { ready? }

      tests('#stats').succeeds do
        @instance.stats
      end

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

      @instance.wait_for { ready? }
      tests('#enable_content_caching').succeeds do
        @instance.enable_content_caching
        returns(true) { @instance.content_caching }
      end

      tests('#enable_content_caching after reload').succeeds do
        @instance.reload
        returns(true) { @instance.content_caching }
      end

      @instance.wait_for { ready? }
      tests('#disable_content_caching').succeeds do
        @instance.disable_content_caching
        returns(false) { @instance.content_caching }
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
      tests("#ssl_termination is nil").returns(nil) do
        @instance.ssl_termination
      end

      @instance.wait_for { ready? }
      tests("#enable_ssl_termination(443, PRIVATE_KEY, CERTIFICATE").succeeds do
        @instance.enable_ssl_termination(443, PRIVATE_KEY, CERTIFICATE)
      end

      @instance.wait_for { ready? }
      tests("#ssl_termination").succeeds do
        @instance.ssl_termination
      end

      @instance.wait_for { ready? }
      tests("#disable_ssl_termination").succeeds do
        @instance.disable_ssl_termination
      end

      @instance.wait_for { ready? }
    end

    tests('create with minimal attributes') do
      @lb = @service.load_balancers.create MINIMAL_LB_ATTRIBUTES

      returns(MINIMAL_LB_ATTRIBUTES[:name]) { @lb.name }
      returns('HTTP') { @lb.protocol }
      returns(80) { @lb.port }

      @lb.wait_for { ready? }

      @lb.destroy
    end

    tests('create with full attributes') do
      @lb = @service.load_balancers.create FULL_LB_ATTRIBUTES
      returns('LEAST_CONNECTIONS') { @lb.algorithm }
      returns(60) { @lb.timeout }

      @lb.wait_for { ready? }

      @lb.destroy
    end

    tests('create with httpsRedirect') do
      @lb = @service.load_balancers.create HTTPS_REDIRECT_LB_ATTRIBUTES
      returns('HTTPS') { @lb.protocol }
      returns(true) { @lb.https_redirect }

      @lb.wait_for { ready? }

      @lb.destroy
    end


    tests('failure') do
      @lb = @service.load_balancers.new NORMAL_LB_ATTRIBUTES
      tests('#usage => Requires ID').raises(ArgumentError) do
        @lb.usage
      end

      tests('#health_monitor => Requires ID').raises(ArgumentError) do
        @lb.health_monitor
      end
    end
  end
end
