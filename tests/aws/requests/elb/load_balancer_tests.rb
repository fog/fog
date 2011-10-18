Shindo.tests('AWS::ELB | load_balancer_tests', ['aws', 'elb']) do
  @load_balancer_id = 'fog-test-elb'
  @key_name = 'fog-test'

  tests('success') do
    @certificate = Fog::AWS[:iam].upload_server_certificate(AWS::IAM::SERVER_CERT_PUBLIC_KEY, AWS::IAM::SERVER_CERT_PRIVATE_KEY, @key_name).body['Certificate']

    tests("#create_load_balancer").formats(AWS::ELB::Formats::CREATE_LOAD_BALANCER) do
      zones = ['us-east-1a']
      listeners = [{'LoadBalancerPort' => 80, 'InstancePort' => 80, 'Protocol' => 'HTTP'}]
      Fog::AWS[:elb].create_load_balancer(zones, @load_balancer_id, listeners).body
    end

    tests("#describe_load_balancers").formats(AWS::ELB::Formats::DESCRIBE_LOAD_BALANCERS) do
      Fog::AWS[:elb].describe_load_balancers.body
    end

    tests('#describe_load_balancers with bad lb') do
      raises(Fog::AWS::ELB::NotFound) { Fog::AWS[:elb].describe_load_balancers('none-such-lb') }
    end

    tests("#describe_load_balancers with SSL listener") do
      sleep 5 unless Fog.mocking?
      listeners = [
        {'Protocol' => 'HTTPS', 'LoadBalancerPort' => 443, 'InstancePort' => 443, 'SSLCertificateId' => @certificate['Arn']},
      ]
      Fog::AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners)
      response = Fog::AWS[:elb].describe_load_balancers(@load_balancer_id).body
      tests("SSLCertificateId is set").returns(@certificate['Arn']) do
        listeners = response["DescribeLoadBalancersResult"]["LoadBalancerDescriptions"].first["ListenerDescriptions"]
        listeners.find {|l| l["Listener"]["Protocol"] == 'HTTPS' }["Listener"]["SSLCertificateId"]
      end
    end

    tests("#configure_health_check").formats(AWS::ELB::Formats::CONFIGURE_HEALTH_CHECK) do
      health_check = {
        'Target' => 'HTTP:80/index.html',
        'Interval' => 10,
        'Timeout' => 5,
        'UnhealthyThreshold' => 2,
        'HealthyThreshold' => 3
      }

      Fog::AWS[:elb].configure_health_check(@load_balancer_id, health_check).body
    end

    tests("#delete_load_balancer").formats(AWS::ELB::Formats::DELETE_LOAD_BALANCER) do
      Fog::AWS[:elb].delete_load_balancer(@load_balancer_id).body
    end

    tests("#delete_load_balancer when non existant").formats(AWS::ELB::Formats::DELETE_LOAD_BALANCER) do
      Fog::AWS[:elb].delete_load_balancer('non-existant').body
    end

    tests("#delete_load_balancer when already deleted").formats(AWS::ELB::Formats::DELETE_LOAD_BALANCER) do
      Fog::AWS[:elb].delete_load_balancer(@load_balancer_id).body
    end

    Fog::AWS[:iam].delete_server_certificate(@key_name)
  end
end
