module Fog
  module Compute
    class OpenStack
      class Real
        def create_volume_snapshot(volume_id, name, description, force=false)
          data = {
            'snapshot' => {
              'volume_id'           => volume_id,
              'display_name'        => name,
              'display_description' => description,
              'force'               => force
            }
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "os-snapshots"
          )
        end
      end

      class Mock
        def create_volume_snapshot(volume_id, name, description, force=false)
          response = Excon::Response.new
          response.status = 202
          response.body = {
            "snapshot"=> {
               "status"=>"creating",
               "display_name"=>name,
               "created_at"=>Time.now,
               "display_description"=>description,
               "volume_id"=>volume_id,
               "id"=>"5",
               "size"=>1
            }
          }
          response
        end
      end
    end
  end
end
