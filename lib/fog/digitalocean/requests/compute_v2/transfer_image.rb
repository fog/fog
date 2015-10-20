module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def transfer_image(id, region)
          body = { :type => 'transfer', :region => region }

          encoded_body = Fog::JSON.encode(body)

          request(
            :expects => [201],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => "v2/images/#{id}/actions",
            :body    => encoded_body,
          )
        end
      end

      class Mock
        def transfer_image(id, name)
          response         = Excon::Response.new
          response.status  = 201
          response.body    = {
            'action' => {
              'id' => 36805527,
              'status' => 'in-progress',
              'type' => 'transfer',
              'started_at' => '2014-11-14T16:42:45Z',
              'completed_at' => null,
              'resource_id' => 7938269,
              'resource_type' => 'image',
              'region' => 'nyc3',
              'region_slug' => 'nyc3'
            }
          }
          response
        end
      end
    end
  end
end
