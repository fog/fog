Shindo.tests('Fog::Rackspace::LoadBalancers | access_lists_tests', ['rackspace']) do

  pending if Fog.mocking?

  given_a_load_balancer_service do
    given_a_load_balancer do
      tests('success') do

        @lb.wait_for { ready? }
        tests("#create_access_rule(#{@lb.id}, '67.0.0.1','ALLOW')").succeeds do
          @service.create_access_rule(@lb.id, '67.0.0.1', 'ALLOW').body
        end

        @lb.wait_for { ready? }
        tests("list_access_rules").formats(ACCESS_LIST_FORMAT) do
          data = @service.list_access_rules(@lb.id).body
          returns(1) { data.size }
          @access_list_id = data['accessList'].first['id']
          data
        end

        @lb.wait_for {ready? }
        tests("delete_access_rule(#{@lb.id}, #{@access_list_id}").succeeds do
          @service.delete_access_rule(@lb.id, @access_list_id)
        end

        @lb.wait_for {ready? }
        tests("delete_all_access_rules(#{@lb.id})").succeeds do
          #This could be refactored once we can add multiple access rules at once
          @service.create_access_rule(@lb.id, '67.0.0.2', 'ALLOW')
          @lb.wait_for {ready? }
          @service.create_access_rule(@lb.id, '67.0.0.3', 'ALLOW')
          @lb.wait_for {ready? }
          returns(2) { @service.list_access_rules(@lb.id).body['accessList'].size }

          @service.delete_all_access_rules(@lb.id)

          @lb.wait_for {ready? }
          returns(0) { @service.list_access_rules(@lb.id).body['accessList'].size }
        end
      end

      tests('failure') do
        tests('create_access_rule(invalid ip)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.create_access_rule(@lb.id, '', 'ALLOW')
        end
        tests('create_access_rule(invalid type)').raises(Fog::Rackspace::LoadBalancers::BadRequest) do
          @service.create_access_rule(@lb.id, '10.10.10.10', 'ENABLED')
        end
        tests("delete_access_rule(#{@lb.id}, 0)").raises(Fog::Rackspace::LoadBalancers::NotFound) do
          @service.delete_access_rule(@lb.id, 0)
        end
      end
    end
  end
end
