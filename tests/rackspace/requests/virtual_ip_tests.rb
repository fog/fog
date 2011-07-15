Shindo.tests('Fog::Rackspace::LoadBalancer | virtual_ip_tests', ['rackspace']) do

  @service = Fog::Rackspace::LoadBalancer.new
  @lb = @service.load_balancers.create({
      :name => ('fog' + Time.now.to_i.to_s),
      :protocol => 'HTTP',
      :port => 80,
      :virtual_ips => [{ :type => 'PUBLIC'}],
      :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
    })

  tests('success') do

    @lb.wait_for { ready? }
    tests('#create_virtual_ip').formats(VIRTUAL_IP_FORMAT) do
      data = @service.create_virtual_ip(@lb.id, 'PUBLIC').body
      @virtual_ip_id = data['id']
      data
    end

    @lb.wait_for { ready? }
    tests("list_virtual_ips").formats(VIRTUAL_IPS_FORMAT) do
      @service.list_virtual_ips(@lb.id).body
    end
  end

  tests('failure') do
    #TODO - I feel like this should really be a BadRequest, need to dig in
    tests('create_virtual_ip(invalid type)').raises(Fog::Rackspace::LoadBalancer::ServiceError) do
      @service.create_virtual_ip(@lb.id, 'badtype')
    end
    tests('delete_virtual_ip(0)').raises(Fog::Rackspace::LoadBalancer::NotFound) do
      @service.delete_virtual_ip(@lb.id, 0)
    end
  end

  tests('success') do
    @lb.wait_for { ready? }
    tests("#delete_virtual_ip(#{@lb.id}, #{@virtual_ip_id})").succeeds do
      @service.delete_virtual_ip(@lb.id, @virtual_ip_id)
    end
  end

  @lb.wait_for { ready? }
  @lb.destroy
end
