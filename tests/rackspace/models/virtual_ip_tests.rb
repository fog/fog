Shindo.tests('Fog::Rackspace::LoadBalancer | virtual_ip', ['rackspace']) do

  @service = Fog::Rackspace::LoadBalancer.new
  @lb = @service.load_balancers.create({
      :name => ('fog' + Time.now.to_i.to_s),
      :protocol => 'HTTP',
      :port => 80,
      :virtual_ips => [{ :type => 'PUBLIC'}],
      :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
    })
  @lb.wait_for { ready? }

  begin
    model_tests(@lb.virtual_ips, { :type => 'PUBLIC'}, false) do
      @lb.wait_for { ready? }

      tests("#save => existing virtual IP").raises(Fog::Errors::Error) do
        @instance.save
      end
    end
  ensure
    @lb.wait_for { ready? }
    @lb.destroy
  end
end
