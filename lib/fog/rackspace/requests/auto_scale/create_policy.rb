module Fog
  module Rackspace
    class AutoScale
      class Real
        def create_policy(group_id, options)
          data = [options]

          request(
            :method => 'POST',
            :body => Fog::JSON.encode(data),
            :path => "groups/#{group_id}/policies",
            :expects => 201
          )
        end
      end

      class Mock
        def create_policy(group_id, options)
          group = self.data[:autoscale_groups][group_id]

          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy = {
            "id" => Fog::Rackspace::MockData.uuid,
            "name" => "set group to 5 servers",
            "desiredCapacity" => 5,
            "cooldown" => 1800,
            "type" => "webhook"
          }

          group['scalingPolicies'] << policy

          body = [policy]

          response(:body => body)
        end
      end
    end
  end
end
