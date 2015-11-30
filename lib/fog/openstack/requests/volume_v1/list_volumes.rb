require 'fog/openstack/requests/volume/list_volumes'

module Fog
  module Volume
    class OpenStack
      class V1
        class Real
          include Fog::Volume::OpenStack::Real
        end

        class Mock
          def list_volumes(options = true, options_deprecated = {})
            response            = Excon::Response.new
            response.status     = 200
            self.data[:volumes] ||= [
                {"status"              => "available",
                 "display_description" => "test 1 desc",
                 "availability_zone"   => "nova",
                 "display_name"        => "Volume1",
                 "attachments"         => [{}],
                 "volume_type"         => nil,
                 "snapshot_id"         => nil,
                 "size"                => 1,
                 "id"                  => 1,
                 "created_at"          => Time.now,
                 "metadata"            => {}},
                {"status"              => "available",
                 "display_description" => "test 2 desc",
                 "availability_zone"   => "nova",
                 "display_name"        => "Volume2",
                 "attachments"         => [{}],
                 "volume_type"         => nil,
                 "snapshot_id"         => nil,
                 "size"                => 1,
                 "id"                  => 2,
                 "created_at"          => Time.now,
                 "metadata"            => {}}
            ]
            response.body       = {'volumes' => self.data[:volumes]}
            response
          end
        end
      end
    end
  end
end
