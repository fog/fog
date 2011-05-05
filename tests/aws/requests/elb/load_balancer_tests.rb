Shindo.tests('AWS::ELB | load_balancer_tests', ['aws', 'elb']) do
  @load_balancer_id = 'fog-test-elb'

  tests('success') do
    pending if Fog.mocking?

    tests("#create_load_balancer").formats(AWS::ELB::Formats::CREATE_LOAD_BALANCER) do
      zones = ['us-east-1a']
      listeners = [{'LoadBalancerPort' => 80, 'InstancePort' => 80, 'Protocol' => 'http'}]
      AWS[:elb].create_load_balancer(zones, @load_balancer_id, listeners).body
    end

    tests("#describe_load_balancers").formats(AWS::ELB::Formats::DESCRIBE_LOAD_BALANCERS) do
      AWS[:elb].describe_load_balancers.body
    end

    tests('#describe_load_balancers with bad lb') do
      raises(Fog::AWS::ELB::NotFound) { AWS[:elb].describe_load_balancers('none-such-lb') }
    end

    tests("#configure_health_check").formats(AWS::ELB::Formats::CONFIGURE_HEALTH_CHECK) do
      health_check = {
        'Target' => 'HTTP:80/index.html',
        'Interval' => 10,
        'Timeout' => 5,
        'UnhealthyThreshold' => 2,
        'HealthyThreshold' => 3
      }

      AWS[:elb].configure_health_check(@load_balancer_id, health_check).body
    end

    tests("#create_app_cookie_stickiness_policy").formats(AWS::ELB::Formats::BASIC) do
      cookie, policy = 'fog-app-cookie', 'fog-app-policy'
      AWS[:elb].create_app_cookie_stickiness_policy(@load_balancer_id, policy, cookie).body
    end

    tests("#create_lb_cookie_stickiness_policy with expiry").formats(AWS::ELB::Formats::BASIC) do
      policy = 'fog-lb-expiry'
      expiry = 300
      AWS[:elb].create_lb_cookie_stickiness_policy(@load_balancer_id, policy, expiry).body
    end

    tests("#create_lb_cookie_stickiness_policy without expiry").formats(AWS::ELB::Formats::BASIC) do
      policy = 'fog-lb-no-expiry'
      AWS[:elb].create_lb_cookie_stickiness_policy(@load_balancer_id, policy).body
    end

    tests("#delete_load_balancer_policy").formats(AWS::ELB::Formats::BASIC) do
      policy = 'fog-lb-no-expiry'
      AWS[:elb].delete_load_balancer_policy(@load_balancer_id, policy).body
    end

    tests("#create_load_balancer_listeners").formats(AWS::ELB::Formats::BASIC) do
      listeners = [
        {'Protocol' => 'tcp', 'LoadBalancerPort' => 443, 'InstancePort' => 443},
        {'Protocol' => 'HTTP', 'LoadBalancerPort' => 80, 'InstancePort' => 80}
      ]
      AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners).body
    end

    tests("#set_load_balancer_policies_of_listener adds policy").formats(AWS::ELB::Formats::BASIC) do
      port, policies = 80, ['fog-lb-expiry']
      body = AWS[:elb].set_load_balancer_policies_of_listener(@load_balancer_id, port, policies).body
    end

    tests("#set_load_balancer_policies_of_listener removes policy").formats(AWS::ELB::Formats::BASIC) do
      port = 80
      body = AWS[:elb].set_load_balancer_policies_of_listener(@load_balancer_id, port, []).body
    end


    tests("#delete_load_balancer_listeners").formats(AWS::ELB::Formats::BASIC) do
      ports = [80, 443]
      AWS[:elb].delete_load_balancer_listeners(@load_balancer_id, ports).body
    end

    tests("#delete_load_balancer").formats(AWS::ELB::Formats::DELETE_LOAD_BALANCER) do
      AWS[:elb].delete_load_balancer(@load_balancer_id).body
    end
  end
end
