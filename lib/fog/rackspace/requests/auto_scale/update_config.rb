module Fog
  module Rackspace
    class AutoScale

      class Real

        def update_config(group_id)

          h = {
             "name" => "workers",
             "cooldown" => 60,
             "minEntities" => 0,
             "maxEntities" => 0,
             "metadata" => {
                  "firstkey" => "this is a string",
                  "secondkey" => "1"
              }
          }

          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/config",
            :body => Fog::JSON.encode(h)
            )
        end
      end

      class Mock
        def update_config(group_id)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end