Shindo.tests('Fog::Compute[:ninefold] | load balancers', ['ninefold']) do

  # NOTE: all of these tests require you to have a vm built with a public IP address.
  tests('success') do

    p Ninefold::Compute::Formats::LoadBalancers::CREATE_LOAD_BALANCER_RULE_RESPONSE
    tests("#create_load_balancer_rule()").formats(Ninefold::Compute::Formats::LoadBalancers::CREATE_LOAD_BALANCER_RULE_RESPONSE) do
      pending if Fog.mocking?
      compute = Fog::Compute[:ninefold]
      public_ip_id = compute.list_public_ip_addresses.first['id']
      create_load_balancer = compute.create_load_balancer_rule(:algorithm => 'roundrobin', :name => 'test',
                                                               :privateport => 1000, :publicport => 2000,
                                                               :publicipid => public_ip_id)
      result = Ninefold::Compute::TestSupport.wait_for_job(create_load_balancer['jobid'])
      compute.delete_load_balancer_rule id: create_load_balancer['id']
      result['jobresult']['loadbalancer']
    end

  end
end
