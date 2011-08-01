Shindo.tests('Fog::Rackspace::LoadBalancer | load_balancers', ['rackspace']) do

  given_a_load_balancer_service do
    @lb_name = 'fog' + Time.now.to_i.to_s
    collection_tests(@service.load_balancers,
      {
        :name => @lb_name,
        :protocol => 'HTTP',
        :port => 80,
        :virtual_ips => [{ :type => 'PUBLIC'}],
        :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
      },
      false) do
      @instance.wait_for { ready? }
    end
  end
end
