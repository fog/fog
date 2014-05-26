Shindo.tests("HP::LB | load balancers requests", ['hp', 'lb', 'load_balancer']) do
  @lb_format = {
    'id'        => String,
    'name'      => String,
    'protocol'  => String,
    'port'      => String,
    'algorithm' => String,
    'status'    => String,
    'created'   => String,
    'updated'   => String,
    'nodes'     => Array
  }

  tests('success') do
    @lb_name = 'fog-lb'
    @nodes = [{'address' => '15.185.1.1', 'port' => '80'}]

    tests("#create_load_balancer(#{@lb_name}, #{@nodes})").formats(@lb_format) do
      data = HP[:lb].create_load_balancer(@lb_name, @nodes).body
      @lb_id = data['id']
      data
    end

    tests('#list_load_balancers').formats({'loadBalancers' => [@lb_format]}) do
      HP[:lb].list_load_balancers.body
    end

    tests("#get_load_balancer(#{@lb_id})").formats(@lb_format) do
      HP[:lb].get_load_balancer(@lb_id).body
    end

    tests("#update_load_balancer(#{@lb_id}, {'name' => 'updated-fog-lb'})").returns('') do
      HP[:lb].update_load_balancer(@lb_id, {'name' => 'updated-fog-lb'}).body
    end

    tests("#delete_load_balancer(#{@lb_id})").succeeds do
      HP[:lb].delete_load_balancer(@lb_id)
    end

  end

  tests('failure') do
    tests("#get_load_balancer(0)").raises(Fog::HP::LB::NotFound) do
      HP[:lb].get_load_balancer('0')
    end

    tests("#update_load_balancer(0, {'name' => 'updated-fog-lb'})").raises(Fog::HP::LB::NotFound) do
      HP[:lb].update_load_balancer('0', {'name' => 'updated-fog-lb'})
    end

    tests("#delete_load_balancer(0)").raises(Fog::HP::LB::NotFound) do
      HP[:lb].delete_load_balancer('0')
    end
  end

end
