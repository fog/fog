Shindo.tests('Fog::Rackspace::LoadBalancers | ssl_termination', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do

        @lb.wait_for { ready? }
        tests("#set_ssl_termination(#{@lb.id}, 443, PRIVATE_KEY, CERTIFICATE)").succeeds do
          @service.set_ssl_termination(@lb.id, 443, PRIVATE_KEY, CERTIFICATE)
        end

        @lb.wait_for { ready? }
        tests("#get_ssl_termination(#{@lb.id})").formats(SSL_TERMINATION_FORMAT) do
          @service.get_ssl_termination(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#remove_ssl_termination(#{@lb.id})").succeeds do
          @service.remove_ssl_termination(@lb.id).body
        end

      end

      tests('failure') do
        @lb.wait_for { ready? }
        tests("#get_ssl_termination(#{@lb.id})").raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.get_ssl_termination(@lb.id).body
        end

        tests("#set_ssl_termination(#{@lb.id}, 443, '', CERTIFICATE)").raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.set_ssl_termination(@lb.id, 443, '', CERTIFICATE)
        end
      end
    end
  end
end
