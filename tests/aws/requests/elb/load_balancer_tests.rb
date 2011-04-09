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

    tests("#delete_load_balancer").formats(AWS::ELB::Formats::DELETE_LOAD_BALANCER) do
      AWS[:elb].delete_load_balancer(@load_balancer_id).body
    end
  end
end
