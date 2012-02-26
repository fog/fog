Shindo.tests('AWS::ELB | models', ['aws', 'elb']) do
  require 'fog'
  @availability_zones = Fog::Compute[:aws].describe_availability_zones('state' => 'available').body['availabilityZoneInfo'].collect{ |az| az['zoneName'] }
  @key_name = 'fog-test-model'

  tests('success') do
    tests('load_balancers') do
      tests('getting a missing elb') do
        returns(nil) { Fog::AWS[:elb].load_balancers.get('no-such-elb') }
      end
    end

    tests('listeners') do
      tests("default attributes") do
        listener = Fog::AWS[:elb].listeners.new
        tests('instance_port is 80').returns(80) { listener.instance_port }
        tests('instance_protocol is HTTP').returns('HTTP') { listener.instance_protocol }
        tests('lb_port is 80').returns(80) { listener.lb_port }
        tests('protocol is HTTP').returns('HTTP') { listener.protocol }
        tests('policy_names is empty').returns([]) { listener.policy_names }
      end

      tests("specifying attributes") do
        attributes = {:instance_port => 2000, :instance_protocol => 'SSL', :lb_port => 2001, :protocol => 'SSL', :policy_names => ['fake'] }
        listener = Fog::AWS[:elb].listeners.new(attributes)
        tests('instance_port is 2000').returns(2000) { listener.instance_port }
        tests('instance_protocol is SSL').returns('SSL') { listener.instance_protocol }
        tests('lb_port is 2001').returns(2001) { listener.lb_port }
        tests('protocol is SSL').returns('SSL') { listener.protocol }
        tests('policy_names is [ fake ]').returns(['fake']) { listener.policy_names }
      end
    end

    elb = nil
    elb_id = 'fog-test'

    tests('create') do
      tests('without availability zones') do
        elb = Fog::AWS[:elb].load_balancers.create(:id => elb_id, :availability_zones => @availability_zones)
        tests("availability zones are correct").returns(@availability_zones.sort) { elb.availability_zones.sort }
        tests("dns names is set").returns(true) { elb.dns_name.is_a?(String) }
        tests("created_at is set").returns(true) { Time === elb.created_at }
        tests("policies is empty").returns([]) { elb.policies }
        tests("default listener") do
          tests("1 listener").returns(1) { elb.listeners.size }
          tests("params").returns(Fog::AWS[:elb].listeners.new.to_params) { elb.listeners.first.to_params }
        end
      end

      tests('with availability zones') do
        azs = @availability_zones[1..-1]
        elb2 = Fog::AWS[:elb].load_balancers.create(:id => "#{elb_id}-2", :availability_zones => azs)
        tests("availability zones are correct").returns(azs.sort) { elb2.availability_zones.sort }
        elb2.destroy
      end

      # Need to sleep here for IAM changes to propgate
      tests('with ListenerDescriptions') do
        @certificate = Fog::AWS[:iam].upload_server_certificate(AWS::IAM::SERVER_CERT_PUBLIC_KEY, AWS::IAM::SERVER_CERT_PRIVATE_KEY, @key_name).body['Certificate']
        sleep(10) unless Fog.mocking?
        listeners = [{
            'Listener' => {
              'LoadBalancerPort' => 2030, 'InstancePort' => 2030, 'Protocol' => 'HTTP'
            },
            'PolicyNames' => []
          }, {
            'Listener' => {
              'LoadBalancerPort' => 443, 'InstancePort' => 443, 'Protocol' => 'HTTPS', 'InstanceProtocol' => 'HTTPS',
              'SSLCertificateId' => @certificate['Arn']
            },
            'PolicyNames' => []
          }]
        elb3 = Fog::AWS[:elb].load_balancers.create(:id => "#{elb_id}-3", 'ListenerDescriptions' => listeners, :availability_zones => @availability_zones)
        tests('there are 2 listeners').returns(2) { elb3.listeners.count }
        tests('instance_port is 2030').returns(2030) { elb3.listeners.first.instance_port }
        tests('lb_port is 2030').returns(2030) { elb3.listeners.first.lb_port }
        tests('protocol is HTTP').returns('HTTP') { elb3.listeners.first.protocol }
        tests('protocol is HTTPS').returns('HTTPS') { elb3.listeners.last.protocol }
        tests('instance_protocol is HTTPS').returns('HTTPS') { elb3.listeners.last.instance_protocol }
        elb3.destroy
      end

      tests('with invalid Server Cert ARN').raises(Fog::AWS::IAM::NotFound) do
        listeners = [{
          'Listener' => {
          'LoadBalancerPort' => 443, 'InstancePort' => 80, 'Protocol' => 'HTTPS', 'InstanceProtocol' => 'HTTPS', "SSLCertificateId" => "fakecert"}
        }]
        Fog::AWS[:elb].load_balancers.create(:id => "#{elb_id}-4", "ListenerDescriptions" => listeners, :availability_zones => @availability_zones)
      end
    end

    tests('all') do
      elb_ids = Fog::AWS[:elb].load_balancers.all.map{|e| e.id}
      tests("contains elb").returns(true) { elb_ids.include? elb_id }
    end

    tests('get') do
      elb_get = Fog::AWS[:elb].load_balancers.get(elb_id)
      tests('ids match').returns(elb_id) { elb_get.id }
    end

    tests('creating a duplicate elb') do
      raises(Fog::AWS::ELB::IdentifierTaken) do
        Fog::AWS[:elb].load_balancers.create(:id => elb_id, :availability_zones => ['us-east-1d'])
      end
    end

    tests('registering an invalid instance') do
      raises(Fog::AWS::ELB::InvalidInstance) { elb.register_instances('i-00000000') }
    end

    tests('deregistering an invalid instance') do
      raises(Fog::AWS::ELB::InvalidInstance) { elb.deregister_instances('i-00000000') }
    end

    server = Fog::Compute[:aws].servers.create
    server.wait_for { ready? }

    tests('register instance') do
      begin
        elb.register_instances(server.id)
      rescue Fog::AWS::ELB::InvalidInstance
        # It may take a moment for a newly created instances to be visible to ELB requests
        raise if @retried_registered_instance
        @retried_registered_instance = true
        sleep 1
        retry
      end

      returns([server.id]) { elb.instances }
    end

    tests('instance_health') do
      returns('OutOfService') do
        elb.instance_health.detect{|hash| hash['InstanceId'] == server.id}['State']
      end

      returns([server.id]) { elb.instances_out_of_service }
    end

    tests('deregister instance') do
      elb.deregister_instances(server.id)
      returns([]) { elb.instances }
    end
    server.destroy

    tests('disable_availability_zones') do
      elb.disable_availability_zones(@availability_zones[1..-1])
      returns(@availability_zones[0..0]) { elb.availability_zones.sort }
    end

    tests('enable_availability_zones') do
      elb.enable_availability_zones(@availability_zones[1..-1])
      returns(@availability_zones) { elb.availability_zones.sort }
    end

    tests('default health check') do
      default_health_check = {
        "HealthyThreshold"=>10,
        "Timeout"=>5,
        "UnhealthyThreshold"=>2,
        "Interval"=>30,
        "Target"=>"TCP:80"
      }
      returns(default_health_check) { elb.health_check }
    end

    tests('configure_health_check') do
      new_health_check = {
        "HealthyThreshold"=>5,
        "Timeout"=>10,
        "UnhealthyThreshold"=>3,
        "Interval"=>15,
        "Target"=>"HTTP:80/index.html"
      }
      elb.configure_health_check(new_health_check)
      returns(new_health_check) { elb.health_check }
    end

    tests('listeners') do
      tests('default') do
        returns(1) { elb.listeners.size }

        listener = elb.listeners.first
        returns([80,80,'HTTP','HTTP', []]) { [listener.instance_port, listener.lb_port, listener.protocol, listener.instance_protocol, listener.policy_names] }
      end

      tests('#get') do
        returns(80) { elb.listeners.get(80).lb_port }
      end

      tests('create') do
        new_listener = { 'InstancePort' => 443, 'LoadBalancerPort' => 443, 'Protocol' => 'TCP', 'InstanceProtocol' => 'TCP'}
        elb.listeners.create(:instance_port => 443, :lb_port => 443, :protocol => 'TCP', :instance_protocol => 'TCP')
        returns(2) { elb.listeners.size }
        returns(443) { elb.listeners.get(443).lb_port }
      end

      tests('destroy') do
        elb.listeners.get(443).destroy
        returns(nil) { elb.listeners.get(443) }
      end
    end

    tests('policies') do
      app_policy_id = 'my-app-policy'

      tests 'are empty' do
        returns([]) { elb.policies.to_a }
      end

      tests('#all') do
        returns([]) { elb.policies.all.to_a }
      end

      tests('create app policy') do
        elb.policies.create(:id => app_policy_id, :cookie => 'my-app-cookie', :cookie_stickiness => :app)
        returns(app_policy_id) { elb.policies.first.id }
      end

      tests('get policy') do
        returns(app_policy_id) { elb.policies.get(app_policy_id).id }
      end

      tests('destroy app policy') do
        elb.policies.first.destroy
        returns([]) { elb.policies.to_a }
      end

      lb_policy_id = 'my-lb-policy'
      tests('create lb policy') do
        elb.policies.create(:id => lb_policy_id, :expiration => 600, :cookie_stickiness => :lb)
        returns(lb_policy_id) { elb.policies.first.id }
      end

      tests('setting a listener policy') do
        elb.set_listener_policy(80, lb_policy_id)
        returns([lb_policy_id]) { elb.listeners.get(80).policy_names }
      end

      tests('unsetting a listener policy') do
        elb.unset_listener_policy(80)
        returns([]) { elb.listeners.get(80).policy_names }
      end

      tests('a malformed policy') do
        raises(ArgumentError) { elb.policies.create(:id => 'foo', :cookie_stickiness => 'invalid stickiness') }
      end
    end

    tests('setting a new ssl certificate id') do
      elb.listeners.create(:instance_port => 443, :lb_port => 443, :protocol => 'HTTPS', :instance_protocol => 'HTTPS', :ssl_id => @certificate['Arn'])
      elb.set_listener_ssl_certificate(443, @certificate['Arn'])
    end

    tests('destroy') do
      elb.destroy
    end

    Fog::AWS[:iam].delete_server_certificate(@key_name)
  end
end
