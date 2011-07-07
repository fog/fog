Shindo.tests('Fog::Rackspace::LoadBalancer | load_balancer_tests', ['rackspace']) do

  @load_balancer_format = {
    'loadBalancer' => {
      'name' => String,
      'id' => Integer,
      'port' => Integer,
      'protocol' => String,
      'algorithm' => String,
      'status' => String,
      'cluster' => { 'name' => String },
      'virtualIps' => [{'type' => String, 'id' => Integer, 'type' => String, 'ipVersion' => String, 'address' => String}],
      'nodes' => [{'address' => String, 'id' => Integer, 'status' => String, 'weight' => Integer, 'port' => Integer, 'condition' => String}],
      'created' => { 'time' => String },
      'updated' => { 'time' => String },
      'connectionLogging' => { 'enabled' => Fog::Boolean }
  }}

  tests('success') do

    @lb_id = nil
    @lb = Fog::Rackspace::LoadBalancer.new

    tests('#create_lb()').formats(@load_balancer_format) do
      data = @lb.create_load_balancer(:name => 'fog' + Time.now.to_i.to_s, :port => '80', :protocol => 'HTTP', :virtualIps => [{ :type => 'PUBLIC'}], :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]).body
      puts data
      @lb_id = data['loadBalancer']['id']
      data
    end

    puts "Sleeping..."
    sleep(60)

    tests("#delete_load_balancer(#{@ld_id})").succeeds do
      @lb.delete_load_balancer(@lb_id)
    end
  end

  tests('failure') do
  end
end
