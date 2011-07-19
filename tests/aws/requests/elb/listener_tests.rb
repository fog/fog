Shindo.tests('AWS::ELB | listener_tests', ['aws', 'elb']) do
  @load_balancer_id = 'fog-test-listener'
  @key_name = 'fog-test'

  tests('success') do
    AWS[:elb].create_load_balancer(['us-east-1a'], @load_balancer_id, [{'LoadBalancerPort' => 80, 'InstancePort' => 80, 'Protocol' => 'HTTP'}])
    @certificate = AWS[:iam].upload_server_certificate(AWS::IAM::SERVER_CERT_PUBLIC_KEY, AWS::IAM::SERVER_CERT_PRIVATE_KEY, @key_name).body['Certificate']

    tests("#create_load_balancer_listeners").formats(AWS::ELB::Formats::BASIC) do
      listeners = [
        {'Protocol' => 'TCP', 'LoadBalancerPort' => 443, 'InstancePort' => 443, 'SSLCertificateId' => @certificate['Arn']},
        {'Protocol' => 'HTTP', 'LoadBalancerPort' => 80, 'InstancePort' => 80}
      ]
      response = AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners).body
      puts response.inspect
      response
    end

    tests("#delete_load_balancer_listeners").formats(AWS::ELB::Formats::BASIC) do
      ports = [80, 443]
      AWS[:elb].delete_load_balancer_listeners(@load_balancer_id, ports).body
    end

    tests("#create_load_balancer_listeners with non-existant SSL certificate") do
      listeners = [
        {'Protocol' => 'HTTPS', 'LoadBalancerPort' => 443, 'InstancePort' => 443, 'SSLCertificateId' => 'non-existant'},
      ]
      raises(Fog::AWS::IAM::NotFound) { AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners) }
    end

    tests("#create_load_balancer_listeners with invalid SSL certificate").raises(Fog::AWS::IAM::NotFound) do
      sleep 8 unless Fog.mocking?
      listeners = [
        {'Protocol' => 'HTTPS', 'LoadBalancerPort' => 443, 'InstancePort' => 443, 'SSLCertificateId' => "#{@certificate['Arn']}fake"},
      ]
      AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners).body
    end

    # This is sort of fucked up, but it may or may not fail, thanks AWS
    tests("#create_load_balancer_listeners with SSL certificate").formats(AWS::ELB::Formats::BASIC) do
      sleep 8 unless Fog.mocking?
      listeners = [
        {'Protocol' => 'HTTPS', 'LoadBalancerPort' => 443, 'InstancePort' => 443, 'SSLCertificateId' => @certificate['Arn']},
      ]
      AWS[:elb].create_load_balancer_listeners(@load_balancer_id, listeners).body
    end

    AWS[:iam].delete_server_certificate(@key_name)
    AWS[:elb].delete_load_balancer(@load_balancer_id)
  end
end
