Shindo.tests("HP::LB | delete load balancer tests", ['hp', 'lb', 'load_balancer']) do
  @good_id = "71"
  @bad_id = "0"
  tests('success') do
    tests("#delete_load_balancer(#{@good_id})").succeeds do
      HP[:lb].delete_load_balancer(@good_id)
    end
  end
  tests('failure') do
    tests("#delete_domain(#{@bad_id})").raises(Fog::HP::LB::NotFound) do
      HP[:lb].delete_load_balancer(@bad_id)
    end
  end

end