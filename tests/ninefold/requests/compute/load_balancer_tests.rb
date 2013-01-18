Shindo.tests('Fog::Compute[:ninefold] | load balancers', ['ninefold']) do

  # NOTE: all of these tests require you to have a vm built with a public IP address.
  tests('success') do

    before do
      @compute = Fog::Compute[:ninefold]
      unless Fog.mocking?
        @public_ip_id = @compute.list_public_ip_addresses.first['id']
        @server_id = @compute.servers.all.first.id
        @create_load_balancer = @compute.create_load_balancer_rule(:algorithm => 'roundrobin', :name => 'test',
                                                                  :privateport => 1000, :publicport => 2000,
                                                                  :publicipid => @public_ip_id)
      end
    end

    after do
      unless Fog.mocking?
        delete = @compute.delete_load_balancer_ruler(:id => @create_load_balancer['id'])
        Ninefold::Compute::TestSupport.wait_for_job(delete['jobid'])
      end
    end

    tests("#create_load_balancer_rule()").formats(Ninefold::Compute::Formats::LoadBalancers::CREATE_LOAD_BALANCER_RULE_RESPONSE) do
      pending if Fog.mocking?
      result = Ninefold::Compute::TestSupport.wait_for_job(@create_load_balancer['jobid'])
      result['jobresult']['loadbalancer']
    end

    tests("#assign_to_load_balancer_rule()").formats(Ninefold::Compute::Formats::LoadBalancers::ASSIGN_LOAD_BALANCER_RULE_RESPONSE) do
      pending if Fog.mocking?
      assign_load_balancer = @compute.assign_to_load_balancer_rule(:id => @create_load_balancer['id'], :virtualmachineids => @server_id)
      result = Ninefold::Compute::TestSupport.wait_for_job(assign_load_balancer['jobid'])
      result['jobresult']
    end

    tests("#list_to_load_balancer_rules()").formats(Ninefold::Compute::Formats::LoadBalancers::LIST_LOAD_BALANCER_RULES_RESPONSE) do
      pending if Fog.mocking?
      list_load_balancer_rules = @compute.list_load_balancer_rules
      list_load_balancer_rules['loadbalancerrule'].first
    end

    tests("#update_to_load_balancer_rule()").formats(Ninefold::Compute::Formats::LoadBalancers::UPDATE_LOAD_BALANCER_RULE_RESPONSE) do
      pending if Fog.mocking?
      update_load_balancer = @compute.update_load_balancer_rule(:id => @create_load_balancer['id'], :algorithm => 'source')
      result = Ninefold::Compute::TestSupport.wait_for_job(update_load_balancer['jobid'])
      result['jobresult']['loadbalancer']
    end

    tests('with assigned to load balancer rule') do
      before do
        unless Fog.mocking?
          assign_load_balancer = @compute.assign_to_load_balancer_rule(:id => @create_load_balancer['id'], :virtualmachineids => @server_id)
          result = Ninefold::Compute::TestSupport.wait_for_job(assign_load_balancer['jobid'])
        end
      end

      tests("#remove_from_load_balancer_rule()").formats(Ninefold::Compute::Formats::LoadBalancers::REMOVE_FROM_LOAD_BALANCER_RULE_RESPONSE) do
        pending if Fog.mocking?
        remove = @compute.remove_from_load_balancer_rule(:id => @create_load_balancer['id'], :virtualmachineids => @server_id)
        result = Ninefold::Compute::TestSupport.wait_for_job(remove['jobid'])
        result['jobresult']
      end
    end
  end
end
