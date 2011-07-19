Shindo.tests('Fog::Rackspace::LoadBalancer | load_balancer_tests', ['rackspace']) do

  @lb = Fog::Rackspace::LoadBalancer.new
  tests('success') do

    @lb_id = nil
    @lb_name = 'fog' + Time.now.to_i.to_s

    tests('#create_load_balancer(fog, )').formats(LOAD_BALANCER_FORMAT) do
      data = @lb.create_load_balancer(@lb_name, 'HTTP', 80, [{ :type => 'PUBLIC'}], [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]).body
      @lb_id = data['loadBalancer']['id']
      data
    end

    tests("#update_load_balancer(#{@lb_id}) while immutable").raises(Fog::Rackspace::LoadBalancer::ServiceError) do
      @lb.update_load_balancer(@lb_id, { :port => 80 }).body
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
    tests('create_load_balancer(invalid name)').raises(Fog::Rackspace::LoadBalancer::BadRequest) do
      @lb.create_load_balancer('', 'HTTP', 80, [{ :type => 'PUBLIC'}], [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}])
    end

    tests('get_load_balancer(0)').raises(Fog::Rackspace::LoadBalancer::NotFound) do
      @lb.get_load_balancer(0)
    end
    tests('delete_load_balancer(0)').raises(Fog::Rackspace::LoadBalancer::NotFound) do
      @lb.delete_load_balancer(0)
    end
    tests('update_load_balancer(0)').raises(Fog::Rackspace::LoadBalancer::NotFound) do
      @lb.update_load_balancer(0, { :name => 'newname' })
    end
  end
end
