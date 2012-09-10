Shindo.tests('Fog::Compute[:ninefold] | load balancers', ['ninefold']) do

  tests('success') do

    tests("#create_load_balancer_rule()").formats(Ninefold::Compute::Formats::LoadBalancers::CREATE_LOAD_BALANCER_RULE_RESPONSE) do
      pending if Fog.mocking?
      job = Fog::Compute[:ninefold].create_load_balancer_rule(:algorithm => 'roundrobin', :name => 'test', :privateport => 1000, :publicport => 2000)
      Ninefold::Compute::TestSupport.wait_for_job(job)['jobresult']['createloadbalancerruleresponse']
    end

  end
end
