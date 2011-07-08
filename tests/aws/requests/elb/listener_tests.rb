Shindo.tests('AWS::ELB | listener_tests', ['aws', 'elb']) do
  @load_balancer_id = 'fog-test-listener'

  tests('success') do
    AWS[:elb].create_load_balancer(['us-east-1a'], @load_balancer_id, [{'LoadBalancerPort' => 80, 'InstancePort' => 80, 'Protocol' => 'HTTP'}])

    tests("#create_load_balancer_listeners").formats(AWS::ELB::Formats::BASIC) do
      listeners = [
        {'Protocol' => 'TCP', 'LoadBalancerPort' => 443, 'InstancePort' => 443},
        {'Protocol' => 'HTTP', 'LoadBalancerPort' => 80, 'InstancePort' => 80}
      ]
      AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners).body
    end

    tests("#delete_load_balancer_listeners").formats(AWS::ELB::Formats::BASIC) do
      ports = [80, 443]
      AWS[:elb].delete_load_balancer_listeners(@load_balancer_id, ports).body
    end

    AWS[:elb].delete_load_balancer(@load_balancer_id)
  end
end
