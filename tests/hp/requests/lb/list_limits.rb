Shindo.tests("Fog::HP::LB | list limits", ['hp', 'lb', 'limits']) do
  @limits_format = {
    'maxLoadBalancerNameLength' => Integer,
    'maxLoadBalancers'          => Integer,
    'maxNodesPerLoadBalancer'   => Integer,
    'maxVIPsPerLoadBalancer'    => Integer,
  }


  tests('success') do

    tests("#list_limits").formats({'limits' => {"absolute" => {"values" => @limits_format }}}) do
      HP[:lb].list_limits.body
    end
  end


end