module Fog
  module Rackspace
    class AutoScale
      class Real

        def create_group(launch_config, group_config, policies)

          body['launchConfiguration'] = {
            'args' => launch_config.args,
            'type' => launch_config.type
          }

          body['groupConfiguration'] = {
            'name' => group_config.name,
            'cooldown' => group_config.cooldown, 
            'maxEntities' => group_config.max_entities,
            'minEntities' => group_config.min_entities,
            'metadata' => group_config.metadata
          }

          body['scalingPolicies'] = policies.collect { |p| p.to_a }

          request(
            :expects => [201],
            :method => 'POST',
            :path => 'groups',
            :body => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def create_group
          Fog::Mock.not_implemented

        end
      end
    end
  end
end
