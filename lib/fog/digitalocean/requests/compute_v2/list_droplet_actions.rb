module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def list_droplet_actions(id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "v2/droplets/#{id}/actions",
          )
        end
      end

      class Mock
        def list_droplet_actions(id)
          response        = Excon::Response.new
          response.status = 201
          response.body   = {
            'actions' => [
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
            ]
          }
          response
        end
      end
    end
  end
end
