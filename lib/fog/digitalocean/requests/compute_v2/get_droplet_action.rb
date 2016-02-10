module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def get_droplet_action(droplet_id, action_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "v2/droplets/#{droplet_id}/actions/#{action_id}",
          )
        end
      end

      class Mock
        def get_droplet_action(droplet_id, action)
          response         = Excon::Response.new
          response.status  = 201
          response.body    = {
            'action' => {
              'id'            => Fog::Mock.random_numbers(1).to_i,
              'status'        => "in-progress",
              'type'          => "change_kernel",
              'started_at'    => "2014-11-14T16:31:00Z",
              'completed_at'  => null,
              'resource_id'   => id,
              'resource_type' => "droplet",
              'region'        => "nyc3",
              'region_slug'   => "nyc3"
            }
          }
          response
        end
      end
    end
  end
end
