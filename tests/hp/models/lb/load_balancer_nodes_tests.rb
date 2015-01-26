Shindo.tests('HP::LB | load balancer nodes collection', ['hp', 'lb', 'node']) do

  attributes = {:name => 'fog-lb', :nodes => [{'address' => '15.185.1.1', 'port' => '80'}]}
  @lb = HP[:lb].load_balancers.create(attributes)

  attributes = {:address => '15.185.1.1', :port => '80'}
  collection_tests(@lb.nodes, attributes, true)

  tests('success') do

    attributes = {:address => '15.185.1.1', :port => '80'}
    @node = @lb.nodes.create(attributes)

    tests('#all').succeeds do
      @lb.nodes.all
    end

    tests("#get(#{@node.id})").succeeds do
      @lb.nodes.get(@node.id)
    end

    @node.destroy
  end

  @lb.destroy

end
