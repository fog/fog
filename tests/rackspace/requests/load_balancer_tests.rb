Shindo.tests('Fog::Rackspace::LoadBalancer | load_balancer_tests', ['rackspace']) do

  NODE_FORMAT = {'address' => String, 'id' => Integer, 'status' => String, 'weight' => Fog::Nullable::Integer, 'port' => Integer, 'condition' => String}
  VIRTUAL_IP_FORMAT = {'type' => String, 'id' => Integer, 'type' => String, 'ipVersion' => String, 'address' => String}

  STATUS_ACTIVE = 'ACTIVE'

  LOAD_BALANCERS_FORMAT = {
    'loadBalancers' => [
      {
        'name' => String,
        'id' => Integer,
        'port' => Integer,
        'protocol' => String,
        'algorithm' => String,
        'status' => String,
        'virtualIps' => [VIRTUAL_IP_FORMAT],
        'nodes' => [NODE_FORMAT],
        'created' => { 'time' => String },
        'updated' => { 'time' => String }
      }]
  }

  LOAD_BALANCER_FORMAT = {
    'loadBalancer' => {
      'name' => String,
      'id' => Integer,
      'port' => Integer,
      'protocol' => String,
      'algorithm' => String,
      'status' => String,
      'cluster' => { 'name' => String },
      'virtualIps' => [VIRTUAL_IP_FORMAT],
      'nodes' => [NODE_FORMAT],
      'created' => { 'time' => String },
      'updated' => { 'time' => String },
      'connectionLogging' => { 'enabled' => Fog::Boolean }
  }}

  tests('success') do

    @lb_id = nil
    @lb = Fog::Rackspace::LoadBalancer.new

    tests('#create_load_balancer()').formats(LOAD_BALANCER_FORMAT) do
      data = @lb.create_load_balancer(:name => 'fog' + Time.now.to_i.to_s, :port => '80', :protocol => 'HTTP', :virtualIps => [{ :type => 'PUBLIC'}], :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]).body
      @lb_id = data['loadBalancer']['id']
      data
    end

    tests("get_load_balancer(#{@lb_id})").formats(LOAD_BALANCER_FORMAT) do
      @lb.get_load_balancer(@lb_id).body
    end

    tests("list_load_balancers()").formats(LOAD_BALANCERS_FORMAT) do
      @lb.list_load_balancers.body
    end

    until @lb.get_load_balancer(@lb_id).body["loadBalancer"]["status"] == STATUS_ACTIVE
      sleep 10
    end


    tests("update_load_balancer()").succeeds do
      @lb.update_load_balancer(@lb_id, { :port => 80 }).body
    end

    until @lb.get_load_balancer(@lb_id).body["loadBalancer"]["status"] == STATUS_ACTIVE
      sleep 10
    end

    tests("#delete_load_balancer(#{@ld_id})").succeeds do
      @lb.delete_load_balancer(@lb_id).body
    end
  end

  tests('failure') do
  end
end
