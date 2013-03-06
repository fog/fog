Shindo.tests("Fog::HP::LB | get load balancer", ['hp', 'lb', 'load_balancers']) do
  @lb_format = {
    'id'         => String,
    'name'       => String,
    'protocol'   => String,
    'port'       => String,
    'algorithm'  => String,
    'status'     => String,
    'created'    => String,
    'updated'    => String,
    'virtualIps' => [Hash],
    'nodes'      => [Hash]
  }




  tests('success') do

    tests("#get_load_balancer").formats(@lb_format) do
      HP[:lb].get_load_balancer('71').body
    end

  end


end