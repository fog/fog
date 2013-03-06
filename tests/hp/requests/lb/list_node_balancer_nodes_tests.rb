

Shindo.tests("Fog::HP::LB | list node balancer nodes", ['hp', 'lb', 'node_balancers','nodes']) do
  @node_format = {
    'id'        => String,
    'address'   => String,
    'port'      => String,
    'condition' => String,
    'status'    => String
  }

  tests('success') do
    tests("#list_node_balancer_nodes").formats({'nodes' => [@node_format]}) do
      HP[:lb].list_load_balancer_nodes('166').body
    end
  end

  tests('failure') do
    tests("#list_node_balancer_nodes(0)").raises(Fog::HP::LB::NotFound) do
      HP[:lb].list_load_balancer_nodes("0")
    end
  end


end