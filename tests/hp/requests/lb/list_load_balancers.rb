Shindo.tests("Fog::HP::LB | list load_balancers", ['hp', 'lb', 'load_balancers']) do
  @lb_format = {
    'name' => String,
    'id' => String,
    'protocol' => String,
    'port' => String,
    'algorithm' => String,
    'status' => String,
    'created' => String,
    'updated'=> String
  }


  tests('success') do

    tests("#list_load_balancers").formats({'loadBalancers' => [@lb_format]}) do
      HP[:lb].list_load_balancers.body
    end
  end


end