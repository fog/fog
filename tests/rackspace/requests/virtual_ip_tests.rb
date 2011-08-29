Shindo.tests('Fog::Rackspace::LoadBalancers | virtual_ip_tests', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do

        @lb.wait_for { ready? }
        tests('#create_virtual_ip').formats(VIRTUAL_IP_FORMAT) do
          data = @service.create_virtual_ip(@lb.id, 'PUBLIC').body
          @virtual_ip_id = data['id']
          data
        end

        @lb.wait_for { ready? }
        tests("list_virtual_ips").formats(VIRTUAL_IPS_FORMAT) do
          @service.list_virtual_ips(@lb.id).body
        end
      end

      tests('failure') do
        #TODO - I feel like this should really be a BadRequest, need to dig in
        tests('create_virtual_ip(invalid type)').raises(Fog::Rackspace::LoadBalancers::InteralServerError) do
          @service.create_virtual_ip(@lb.id, 'badtype')
        end
        tests('delete_virtual_ip(0)').raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.delete_virtual_ip(@lb.id, 0)
        end
      end

      tests('success') do
        @lb.wait_for { ready? }
        tests("#delete_virtual_ip(#{@lb.id}, #{@virtual_ip_id})").succeeds do
          @service.delete_virtual_ip(@lb.id, @virtual_ip_id)
        end
      end
    end
  end
end
