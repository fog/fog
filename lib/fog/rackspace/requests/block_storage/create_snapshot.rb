module Fog
  module Rackspace
    class BlockStorage
      class Real
        def create_snapshot(volume_id, options = {})
          data = {
            'snapshot' => {
              'volume_id' => volume_id
            }
          }

          data['snapshot']['display_name'] = options[:display_name] unless options[:display_name].nil?
          data['snapshot']['display_description'] = options[:display_description] unless options[:display_description].nil?
          data['snapshot']['force'] = options[:force] unless options[:force].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "snapshots"
          )
        end
      end

      class Mock
        def create_snapshot(volume_id, options = {})
          volume = self.data[:volumes][volume_id]
          if volume.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            snapshot_id         = Fog::Rackspace::MockData.uuid
            display_name        = options[:display_name] || "test snapshot"
            display_description = options[:display_description] || "test snapshot description"

            snapshot = {
              "id"                  => snapshot_id,
              "display_name"        => display_name,
              "display_description" => display_description,
              "volume_id"           => volume_id,
              "status"              => "available",
              "size"                => volume["size"],
              "created_at"          => Fog::Rackspace::MockData.zulu_time,
              "availability_zone"   => "nova",
            }

            self.data[:snapshots][snapshot_id] = snapshot

            response(:body => {"snapshot" => snapshot})
          end
        end
      end
    end
  end
end
