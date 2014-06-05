module Fog
  module Rackspace
    class AutoScale
      class Real
        def create_group(launch_config, group_config, policies)
          body = {
            'launchConfiguration' => launch_config,
            'groupConfiguration' => group_config,
            'scalingPolicies' => policies
          }

          request(
            :expects => [201],
            :method => 'POST',
            :path => 'groups',
            :body => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def create_group(launch_config, group_config, policies)
          group_id = Fog::Rackspace::MockData.uuid

          # Construct group structure
          group = {
            'launchConfiguration' => launch_config,
            'groupConfiguration' => group_config,
            'scalingPolicies' => policies,
            'id' => group_id
          }

          # Add links for HTTP response
          group['scalingPolicies'][0]['links'] = [
            {
              "href" => "https://ord.autoscale.api.rackspacecloud.com/v1.0/829409/groups/6791761b-821a-4d07-820d-0b2afc7dd7f6/policies/dceb14ac-b2b3-4f06-aac9-a5b6cd5d40e1/",
              "rel" => "self"
            }
          ]

          group['links'] = [
            {
              "href" => "https://ord.autoscale.api.rackspacecloud.com/v1.0/829409/groups/6791761b-821a-4d07-820d-0b2afc7dd7f6/",
              "rel" => "self"
            }
          ]

          # Save for future use
          self.data[:autoscale_groups][group_id] = group

          # Response
          body = {'group' => group}
          response(:body => body)
        end
      end
    end
  end
end
