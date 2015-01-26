Shindo.tests('HP::LB | load balancer model', ['hp', 'lb', 'load_balancer']) do

  attributes = {:name => 'fog-lb', :nodes => [{'address' => '15.185.1.1', 'port' => '80'}]}
  model_tests(HP[:lb].load_balancers, attributes, true)

end
