Shindo.tests('Fog::Rackspace::LoadBalancers | node_tests', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      @nodes_created = []

      tests('success') do

        @lb.wait_for { ready? }
        tests("#create_node(#{@lb.id}, '1.1.1.2', 80, 'ENABLED')").formats(NODES_FORMAT) do
          data = @service.create_node(@lb.id, '1.1.1.2', 80, 'ENABLED').body
          @nodes_created << data['nodes'][0]['id']
          data
        end

        @lb.wait_for { ready? }
        tests('#create_node with weight').formats(NODES_FORMAT) do
          data = @service.create_node(@lb.id, '1.1.1.3', 80, 'ENABLED', { :weight => 10 }).body
          @nodes_created << data['nodes'][0]['id']
          data
        end

        @lb.wait_for { ready? }
        tests('#create_node with type').formats(NODES_FORMAT) do
          data = @service.create_node(@lb.id, '1.1.1.4', 80, 'ENABLED', { :type => 'PRIMARY' }).body
          @nodes_created << data['nodes'][0]['id']
          data
        end

        @lb.wait_for { ready? }
        tests("#list_nodes(#{@lb.id})").formats(NODES_FORMAT) do
          @service.list_nodes(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#get_node(#{@lb.id})").formats(NODE_FORMAT) do
          @service.get_node(@lb.id, @nodes_created[0]).body
        end

        @lb.wait_for { ready? }
        tests("#update_node(#{@lb.id}, #{@nodes_created[0]}, { :condition => 'DISABLED' })").succeeds do
          @service.update_node(@lb.id, @nodes_created[0], { :condition => 'DISABLED' })
        end

        @lb.wait_for { ready? }
        tests("#update_node(#{@lb.id}, #{@nodes_created[0]}, { :weight => 20})").succeeds do
          @service.update_node(@lb.id, @nodes_created[0], { :weight => 20 })
        end

        @lb.wait_for { ready? }
        tests("#update_node(#{@lb.id}, #{@nodes_created[0]}, { :condition => 'DISABLED', :weight => 20 })").succeeds do
          @service.update_node(@lb.id, @nodes_created[0], { :condition => 'DISABLED', :weight => 20 })
        end
      end

      tests('failure') do
        tests('#create_node(invalid ip)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.create_node(@lb.id, '', 80, 'ENABLED')
        end
        tests('#create_node(invalid condition)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.create_node(@lb.id, '1.1.1.2', 80, 'EABLED')
        end
        tests("#get_node(#{@lb.id}, 0)").raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.get_node(@lb.id, 0)
        end
        tests("#delete_node(#{@lb.id}, 0)").raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.delete_node(@lb.id, 0)
        end
        tests("#delete_nodes('a', 'b')").raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.delete_nodes(@lb.id, 'a', 'b')
        end
        tests("#update_node(#{@lb.id}, 0, { :weight => 20 })").raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.update_node(@lb.id, 0, { :weight => 20 })
        end
      end

      tests('success') do
        @lb.wait_for { ready? }
        tests("#delete_nodes(multiple node)").succeeds do
          @service.delete_nodes(@lb.id, *@nodes_created)
        end
        @lb.wait_for { ready? }
        tests("#delete_node()").succeeds do
          node_id = @service.create_node(@lb.id, '1.1.1.3', 80, 'ENABLED').body['nodes'][0]['id']
          @lb.wait_for { ready? }
          @service.delete_node(@lb.id, node_id)
        end
      end
    end
  end
end
