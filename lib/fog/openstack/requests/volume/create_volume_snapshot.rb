module Fog
  module Volume
    class OpenStack
      class Real
        def create_volume_snapshot(volume_id, name, description, force=false)
          # some attributes have different keys depending on the volume API version
          name_key, desc_key = [ 'name', 'description' ]
          if @volume_api_version == 'v1'
            name_key, desc_key = [ 'display_name', 'display_description' ]
          end

          data = {
            'snapshot' => {
              'volume_id' => volume_id,
              name_key    => name,
              desc_key    => description,
              'force'     => force
            }
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "snapshots"
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
               "name"=>name,
               "created_at"=>Time.now,
               "description"=>description,
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
