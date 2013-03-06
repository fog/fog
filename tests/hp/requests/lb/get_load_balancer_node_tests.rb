Shindo.tests("Fog::HP::LB | get load balancer node", ['hp', 'lb', 'load_balancers', 'nodes']) do
  @lb_format = {
    'id'         => String,
    'address'  => String,
    'port'     => String,
    'condition'    => String,
    'status'    => String,
  }
  tests('success') do

    tests("#get_load_balancer_node").formats(@lb_format) do
      HP[:lb].get_load_balancer_node('71','1041').body
    end


  end
  tests('failure') do
    tests("#get_load_balancer_node").raises (Fog::HP::LB::NotFound) do
      HP[:lb].get_load_balancer_node('71', '0')
    end

  end

end