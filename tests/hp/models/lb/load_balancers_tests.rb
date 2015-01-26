Shindo.tests('HP::LB | load balancer collection', ['hp', 'lb', 'load_balancer']) do

  attributes = {:name => 'fog-lb', :nodes => [{'address' => '15.185.1.1', 'port' => '80'}]}
  collection_tests(HP[:lb].load_balancers, attributes, true)

  tests('success') do

    attributes = {:name => 'fog-lb', :nodes => [{'address' => '15.185.1.1', 'port' => '80'}]}
    @lb = HP[:lb].load_balancers.create(attributes)

    tests('#all').succeeds do
      HP[:lb].load_balancers.all
    end

    tests("#get(#{@lb.id})").succeeds do
      HP[:lb].load_balancers.get(@lb.id)
    end

    @lb.destroy
  end

end
