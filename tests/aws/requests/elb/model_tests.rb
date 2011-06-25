Shindo.tests('AWS::ELB | models', ['aws', 'elb']) do


  tests('success') do
    pending if Fog.mocking?

    tests('load_balancers') do
      tests('getting a missing elb') do
        returns(nil) { AWS[:elb].load_balancers.get('no-such-elb') }
      end
    end

    elb = nil
    elb_id = 'fog-test'

    tests('create') do
      elb = AWS[:elb].load_balancers.create(:id => elb_id)
      tests("dns names is set").returns(true) { elb.dns_name.is_a?(String) }
      tests("created_at is set").returns(true) { Time === elb.created_at }
      tests("policies is empty").returns([]) { elb.policies }
    end

    tests('all') do
      elb_ids = AWS[:elb].load_balancers.all.map{|e| e.id}
      tests("contains elb").returns(true) { elb_ids.include? elb_id }
    end

    tests('get') do
      elb2 = AWS[:elb].load_balancers.get(elb_id)
      tests('ids match').returns(elb_id) { elb2.id }
    end

    tests('createing a duplicate elb') do
      raises(Fog::AWS::ELB::IdentifierTaken) do
        AWS[:elb].load_balancers.create(:id => elb_id, :availability_zones => ['us-east-1d'])
      end
    end

    tests('registering an invalid instance') do
      raises(Fog::AWS::ELB::InvalidInstance) { elb.register_instances('i-00000000') }
    end

    tests('deregistering an invalid instance') do
      raises(Fog::AWS::ELB::InvalidInstance) { elb.deregister_instances('i-00000000') }
    end

    server = Compute[:aws].servers.create
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
      elb.disable_availability_zones(%w{us-east-1c us-east-1d})
      returns(%w{us-east-1a us-east-1b}) { elb.availability_zones.sort }
    end

    tests('enable_availability_zones') do
      elb.enable_availability_zones(%w{us-east-1c us-east-1d})
      returns(%w{us-east-1a us-east-1b us-east-1c us-east-1d}) { elb.availability_zones.sort }
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
      default_listener_description = [{"Listener"=>{"InstancePort"=>80, "Protocol"=>"HTTP", "LoadBalancerPort"=>80}, "PolicyNames"=>[]}]
      tests('default') do
        returns(1) { elb.listeners.size }

        listener = elb.listeners.first
        returns([80,80,'HTTP', []]) { [listener.instance_port, listener.lb_port, listener.protocol, listener.policy_names] }

      end

      tests('#get') do
        returns(80) { elb.listeners.get(80).lb_port }
      end

      tests('create') do
        new_listener = { 'InstancePort' => 443, 'LoadBalancerPort' => 443, 'Protocol' => 'TCP'}
        elb.listeners.create(:instance_port => 443, :lb_port => 443, :protocol => 'TCP')
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

    tests('destroy') do
      elb.destroy
    end
  end

end
