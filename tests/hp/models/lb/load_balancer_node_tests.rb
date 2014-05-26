Shindo.tests('HP::LB | load balancer node model', ['hp', 'lb', 'node']) do

  attributes = {:name => 'fog-lb', :nodes => [{'address' => '15.185.1.1', 'port' => '80'}]}
  @lb = HP[:lb].load_balancers.create(attributes)

  attributes = {:address => '15.185.1.1', :port => '80'}
  model_tests(@lb.nodes, attributes, true)

end
