Shindo.tests("HP::LB | limits requests", ['hp', 'lb', 'limits']) do
  @limits_format = {
    'maxLoadBalancerNameLength' => Integer,
    'maxLoadBalancers'          => Integer,
    'maxNodesPerLoadBalancer'   => Integer,
    'maxVIPsPerLoadBalancer'    => Integer,
  }

  tests('success') do

    tests('#list_limits').formats({'limits' => [{'values' => @limits_format }]}) do
      HP[:lb].list_limits.body
    end
  end

end
