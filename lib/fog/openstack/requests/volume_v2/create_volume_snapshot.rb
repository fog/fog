module Fog
  module Volume
    class OpenStack
      class V2
        class Real
          def create_volume_snapshot(volume_id, name, description, force=false)
            data = {
                'snapshot' => {
                    'volume_id'   => volume_id,
                    'name'        => name,
                    'description' => description,
                    'force'       => force
                }
            }

            _create_volume_snapshot(data)
          end

          include Fog::Volume::OpenStack::Real
        end

        class Mock
          def create_volume_snapshot(volume_id, name, description, force=false)
            response        = Excon::Response.new
            response.status = 202
            response.body   = {
                "snapshot" => {
                    "status"      => "creating",
                    "name"        => name,
                    "created_at"  => Time.now,
                    "description" => description,
                    "volume_id"   => volume_id,
                    "id"          => "5",
                    "size"        => 1
                }
            }
            response
          end
        end
      end
    end
  end
end
