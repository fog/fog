Shindo.tests('Fog::Rackspace::LoadBalancers | load_balancer_tests', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      @nodes_created = []

      tests('success') do

        @lb.wait_for { ready? }
        tests('#create_node').formats(NODES_FORMAT) do
          data = @service.create_node(@lb.id, '10.10.10.10', 80, 'ENABLED').body
          @nodes_created << data['nodes'][0]['id']
          data
        end

        @lb.wait_for { ready? }
        tests('#create_node with weight').formats(NODES_FORMAT) do
          data = @service.create_node(@lb.id, '10.10.10.11', 80, 'ENABLED', { :weight => 10 }).body
          @nodes_created << data['nodes'][0]['id']
          data
        end

        @lb.wait_for { ready? }
        tests("list_nodes").formats(NODES_FORMAT) do
          @service.list_nodes(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("get_node(#{@lb_node_id})").formats(NODE_FORMAT) do
          @service.get_node(@lb.id, @nodes_created[0]).body
        end

        tests("update_node(#{@lb.id}, #{@nodes_created[0]})").succeeds do

          @lb.wait_for { ready? }
          tests("condition").succeeds do
            @service.update_node(@lb.id, @nodes_created[0], { :condition => 'DISABLED' })
          end

          @lb.wait_for { ready? }
          tests("weight").succeeds do
            @service.update_node(@lb.id, @nodes_created[0], { :weight => 20 })
          end

          @lb.wait_for { ready? }
          tests("condition and weight").succeeds do
            @service.update_node(@lb.id, @nodes_created[0], { :condition => 'DISABLED', :weight => 20 })
          end
        end
      end

      tests('failure') do
        tests('create_node(invalid ip)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.create_node(@lb.id, '', 80, 'ENABLED')
        end
        tests('create_node(invalid condition)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.create_node(@lb.id, '10.10.10.10', 80, 'EABLED')
        end
        tests('get_node(0)').raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.get_node(@lb.id, 0)
        end
        tests('delete_nodes(0)').raises(Fog::Rackspace::LoadBalancers::ServiceError) do
          @service.delete_nodes(@lb.id, 0)
        end
        tests('update_node(0)').raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.update_node(@lb.id, 0, { :weight => 20 })
        end
      end

      tests('success') do
        @lb.wait_for { ready? }
        tests("#delete_nodes(multiple node)").succeeds do
          pending
          @service.delete_nodes(@lb.id, *@nodes_created)
        end
        @lb.wait_for { ready? }
        tests("#delete_node()").succeeds do
          node_id = @service.create_node(@lb.id, '10.10.10.12', 80, 'ENABLED').body['nodes'][0]['id']
          @lb.wait_for { ready? }
          @service.delete_node(@lb.id, node_id)
        end
      end
    end
  end
end
