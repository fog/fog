Shindo.tests('Fog::Rackspace::LoadBalancers | error_page', ['rackspace', 'loadbalancers']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do

        @lb.wait_for { ready? }
        tests("#get_error_page(#{@lb.id})").formats(ERROR_PAGE_FORMAT) do
          @service.get_error_page(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#set_error_page(#{@lb.id}, '<html><body>hi!</body></html>')").succeeds do
          @service.set_error_page(@lb.id, '<html><body>hi!</body></html>')
        end

        @lb.wait_for { ready? }
        tests("#get_error_page(#{@lb.id})").formats(ERROR_PAGE_FORMAT) do
          @service.get_error_page(@lb.id).body
        end

        @lb.wait_for { ready? }
        tests("#remove_error_page()").succeeds do
          @service.remove_error_page(@lb.id)
        end
      end
    end
  end
end
