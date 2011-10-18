Shindo.tests('AWS::ELB | policy_tests', ['aws', 'elb']) do
  @load_balancer_id = 'fog-test-policies'

  tests('success') do
    listeners = [{'LoadBalancerPort' => 80, 'InstancePort' => 80, 'Protocol' => 'HTTP'}]
    Fog::AWS[:elb].create_load_balancer(['us-east-1a'], @load_balancer_id, listeners)

    tests("#create_app_cookie_stickiness_policy").formats(AWS::ELB::Formats::BASIC) do
      cookie, policy = 'fog-app-cookie', 'fog-app-policy'
      Fog::AWS[:elb].create_app_cookie_stickiness_policy(@load_balancer_id, policy, cookie).body
    end

    tests("#create_lb_cookie_stickiness_policy with expiry").formats(AWS::ELB::Formats::BASIC) do
      policy = 'fog-lb-expiry'
      expiry = 300
      Fog::AWS[:elb].create_lb_cookie_stickiness_policy(@load_balancer_id, policy, expiry).body
    end

    tests("#create_lb_cookie_stickiness_policy without expiry").formats(AWS::ELB::Formats::BASIC) do
      policy = 'fog-lb-no-expiry'
      Fog::AWS[:elb].create_lb_cookie_stickiness_policy(@load_balancer_id, policy).body
    end

    tests("#delete_load_balancer_policy").formats(AWS::ELB::Formats::BASIC) do
      policy = 'fog-lb-no-expiry'
      Fog::AWS[:elb].delete_load_balancer_policy(@load_balancer_id, policy).body
    end

    tests("#set_load_balancer_policies_of_listener adds policy").formats(AWS::ELB::Formats::BASIC) do
      port, policies = 80, ['fog-lb-expiry']
      Fog::AWS[:elb].set_load_balancer_policies_of_listener(@load_balancer_id, port, policies).body
    end

    tests("#set_load_balancer_policies_of_listener removes policy").formats(AWS::ELB::Formats::BASIC) do
      port = 80
      Fog::AWS[:elb].set_load_balancer_policies_of_listener(@load_balancer_id, port, []).body
    end

    Fog::AWS[:elb].delete_load_balancer(@load_balancer_id)
  end
end
