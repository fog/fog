Shindo.tests('HP::LB | load balancer virtual ips collection', ['hp', 'lb', 'virtual_ip']) do

  attributes = {:name => 'fog-lb', :nodes => [{'address' => '15.185.1.1', 'port' => '80'}]}
  @lb = HP[:lb].load_balancers.create(attributes)

  tests('success') do

    @vip = HP[:lb].virtual_ips(:load_balancer => @lb).all.first

    tests('#all').succeeds do
      HP[:lb].virtual_ips(:load_balancer => @lb).all
    end

    tests("#get(#{@vip.id})").succeeds do
      HP[:lb].virtual_ips(:load_balancer => @lb).get(@vip.id)
    end

  end

  @lb.destroy

end
