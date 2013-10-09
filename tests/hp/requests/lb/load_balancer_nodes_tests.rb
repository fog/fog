Shindo.tests("HP::LB | load balancer nodes", ['hp', 'lb', 'nodes']) do
  @node_format = {
    'id'        => String,
    'address'   => String,
    'port'      => String,
    'condition' => String,
    'status'    => String
  }

  tests('success') do
    @nodes = [{'address' => '15.185.2.2', 'port' => '88'}]
    data = HP[:lb].create_load_balancer('rg-fog-lb2', [{'address' => '15.185.1.1', 'port' => '80'}]).body
    @lb_id = data['id']

    tests("#create_load_balancer_node(#{@lb_id}, #{@nodes})").formats({'nodes' => [@node_format]}) do
      data = HP[:lb].create_load_balancer_node(@lb_id, @nodes).body
      @lb_node_id = data['id']
      data
    end

    tests("#list_load_balancer_nodes(#{@lb_id})").formats({'nodes' => [@node_format]}) do
      HP[:lb].list_load_balancer_nodes(@lb_id).body
    end

    tests("#get_load_balancer_node(#{@lb_id}, #{@lb_node_id})").formats([@node_format]) do
      HP[:lb].get_load_balancer_node(@lb_id, @lb_node_id).body
    end

    #tests("#update_load_balancer_node(#{@lb_id}, #{@lb_node_id}, 'DISABLED')").succeeds do
    #  HP[:lb].update_load_balancer_node(@lb_id, @lb_node_id, 'DISABLED')
    #end

    tests("#delete_load_balancer_node(#{@lb_id}, #{@lb_node_id})").succeeds do
      HP[:lb].delete_load_balancer_node(@lb_id, @lb_node_id)
    end

    HP[:lb].delete_load_balancer(@lb_id)

  end

  tests('failure') do
    tests('#list_node_balancer_nodes(0)').raises(Fog::HP::LB::NotFound) do
      HP[:lb].list_load_balancer_nodes('0')
    end
  end


end