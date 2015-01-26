Shindo.tests("HP::LB | virtual ips requests", ['hp', 'lb', 'virtual_ips']) do
  @virtual_ips_format = {
    'id'        => String,
    'address'   => String,
    'type'      => String,
    'ipVersion' => String
  }

  tests('success') do
    @nodes = [{'address' => '15.185.1.1', 'port' => '80'}]
    @virtual_ip = [{
                     'ipVersion' => 'IPV4',
                     'type' => 'PUBLIC',
                     'id' => '11111111',
                     'address' => '15.185.3.3'
                  }]
    data = HP[:lb].create_load_balancer('rg-fog-lb3', @nodes, {'virtualIps' => @virtual_ip}).body
    @lb_id = data['id']

    tests('#list_load_balancer_virtual_ips').formats({'virtualIps' => [@virtual_ips_format]}) do
      HP[:lb].list_load_balancer_virtual_ips(@lb_id).body
    end

    HP[:lb].delete_load_balancer(@lb_id)

  end

  tests('failure') do
    tests('#list_load_balancer_virtual_ips(0)').raises(Fog::HP::LB::NotFound) do
      HP[:lb].list_load_balancer_virtual_ips('0')
    end
  end

end
