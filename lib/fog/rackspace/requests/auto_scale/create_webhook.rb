module Fog
  module Rackspace
    class AutoScale
      class Real
        def create_webhook(group_id, policy_id, options)
          body = [options]

          request(
            :method => 'POST',
            :body => Fog::JSON.encode(body),
            :path => "groups/#{group_id}/policies/#{policy_id}/webhooks",
            :expects => 201
          )
        end
      end

      class Mock
        def create_webhook(group_id, policy_id, options)
          group = self.data[:autoscale_groups][group_id]
          if group.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          policy = group['scalingPolicies'].find { |p| p["id"] == policy_id }
          if policy.nil?
            raise Fog::Rackspace::AutoScale::NotFound
          end

          webhook_id = Fog::Rackspace::MockData.uuid

          webhook = {}
          webhook['id'] = webhook_id
          webhook['name'] = options['name'] || 'new webhook'
          webhook['metadata'] = options['name'] || {}
          webhook["links"] = [
            {
              "href" => "https://ord.autoscale.api.rackspacecloud.com/v1.0/829409/groups/#{group_id}/policies/#{policy_id}/webhooks/#{webhook_id}/",
              "rel" => "self"
            },
            {
              "href" => "https://ord.autoscale.api.rackspacecloud.com/v1.0/829409/execute/1/sadfadsfasdfvcjsdfsjvreaigae5",
              "rel" => "capability"
            }
          ]

          policy['webhooks'] << webhook

          body = {'webhook' => webhook}
          response(:body => body)
        end
      end
    end
  end
end
