Shindo.tests('Fog::Rackspace::LoadBalancers | load_balancer_tests', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    tests('success') do

      @lb_id = nil
      @lb_name = 'fog' + Time.now.to_i.to_s

      tests('#create_load_balancer(fog, )').formats(LOAD_BALANCER_FORMAT) do
        data = @service.create_load_balancer(@lb_name, 'HTTP', 80, [{ :type => 'PUBLIC'}], [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]).body
        @lb_id = data['loadBalancer']['id']
        data
      end

      tests("#update_load_balancer(#{@lb_id}) while immutable").raises(Fog::Rackspace::LoadBalancers::ServiceError) do
        @service.update_load_balancer(@lb_id, { :port => 80 }).body
      end

      tests("#get_load_balancer(#{@lb_id})").formats(LOAD_BALANCER_FORMAT) do
        @service.get_load_balancer(@lb_id).body
      end

      tests("#list_load_balancers()").formats(LOAD_BALANCERS_FORMAT) do
        @service.list_load_balancers.body
      end

      until @service.get_load_balancer(@lb_id).body["loadBalancer"]["status"] == STATUS_ACTIVE
        sleep 10
      end


      tests("#update_load_balancer(#{@lb_id}, { :port => 80 })").succeeds do
        @service.update_load_balancer(@lb_id, { :port => 80 }).body
      end

      until @service.get_load_balancer(@lb_id).body["loadBalancer"]["status"] == STATUS_ACTIVE
        sleep 10
      end

      tests("#delete_load_balancer(#{@ld_id})").succeeds do
        @service.delete_load_balancer(@lb_id).body
      end
    end

    tests('failure') do
      tests('#create_load_balancer(invalid name)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
        @service.create_load_balancer('', 'HTTP', 80, [{ :type => 'PUBLIC'}], [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}])
      end

      tests('#get_load_balancer(0)').raises(Fog::Rackspace::LoadBalancers::NotFound) do
        @service.get_load_balancer(0)
      end
      tests('#delete_load_balancer(0)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
        @service.delete_load_balancer(0)
      end
      tests('#update_load_balancer(0)').raises(Fog::Rackspace::LoadBalancers::NotFound) do
        @service.update_load_balancer(0, { :name => 'newname' })
      end
    end
  end
end
