Shindo.tests("HP::LB | delete load balancer node tests", ['hp', 'lb', 'load_balancer', 'nodes']) do
  @good_id = "71"
  @bad_id = "0"
  @good_node = '1041'
  tests('success') do
    tests("#delete_load_balancer_node(#{@good_id}, #{@good_node})").succeeds do
      HP[:lb].delete_load_balancer_node(@good_id,@good_node)
    end
  end
  tests('failure') do
    tests("#delete_domain(#{@bad_id})").raises(Fog::HP::LB::NotFound) do
      HP[:lb].delete_load_balancer_node(@good_id,@bad_id)
    end
  end

end