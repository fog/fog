module Fog
  module Rackspace
    class AutoScale
      class Real
        def get_group_state(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/state"
          )
        end
      end

      class Mock
        def get_group_state(group_id)
          instance_id_1 = Fog::Rackspace::AutoScale::MockData.uuid
          instance_id_2 = Fog::Rackspace::AutoScale::MockData.uuid

          state = {
            "id" => group_id,
            "links" => [
              {
                "href" => "https://dfw.autoscale.api.rackspacecloud.com/v1.0/010101/groups/#{group_id}",
                "rel" => "self"
              }
            ],
            "active" => [
              {
                "id" => "#{instance_id_1}",
                "links" => [
                  {
                    "href" => "https://dfw.servers.api.rackspacecloud.com/v2/010101/servers/#{instance_id_1}",
                    "rel" => "self"
                  }
                ]
              },
              {
                "id" => "#{instance_id_2}",
                "links" => [
                  {
                    "href" => "https://dfw.servers.api.rackspacecloud.com/v2/010101/servers/#{instance_id_2}",
                    "rel" => "self"
                  }
                ]
              }
            ],
            "activeCapacity" => 2,
            "pendingCapacity" => 2,
            "desiredCapacity" => 4,
            "paused" => false
          }

          response(:body => {'group' => state})
        end
      end
    end
  end
end
