module Shindo
  class Tests
    def given_a_load_balancer_service(&block)
      @service = Fog::Rackspace::LoadBalancers.new
      instance_eval(&block)
    end
    def given_a_load_balancer(&block)
        @lb = @service.load_balancers.create({
            :name => ('fog' + Time.now.to_i.to_s),
            :protocol => 'HTTP',
            :port => 80,
            :virtual_ips => [{ :type => 'PUBLIC'}],
            :nodes => [{ :address => '10.0.0.1', :port => 80, :condition => 'ENABLED'}]
          })
        @lb.wait_for { ready? }
      begin
        instance_eval(&block)
      ensure
        @lb.wait_for { ready? }
        @lb.destroy
      end
    end
  end
end
