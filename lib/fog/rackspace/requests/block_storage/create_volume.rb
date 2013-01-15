module Fog
  module Rackspace
    class BlockStorage
      class Real
        def create_volume(size, options = {})
          data = {
            'volume' => {
              'size' => size
            }
          }

          data['volume']['display_name'] = options[:display_name] unless options[:display_name].nil?
          data['volume']['display_description'] = options[:display_description] unless options[:display_description].nil?
          data['volume']['volume_type'] = options[:volume_type] unless options[:volume_type].nil?
          data['volume']['availability_zone'] = options[:availability_zone] unless options[:availability_zone].nil?

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "volumes"
          )
        end
      end

      class Mock
        def create_volume(size, options = {})
          if size < 1 && !options[:snapshot_id]
            raise Fog::Rackspace::BlockStorage::BadRequest
          elsif size < 100 || size > 1024
            raise Fog::Rackspace::BlockStorage::BadRequest.new("'size' parameter must be between 100 and 1024")
          else
            volume_id         = Fog::Rackspace::MockData.uuid
            name              = options[:display_name] || "test volume"
            description       = options[:display_description] || "description goes here"
            volume_type       = options[:volume_type] || "SATA"

            volume = {
              "id"                  => volume_id,
              "display_name"        => name,
              "display_description" => description,
              "size"                => size,
              "status"              => "available",
              "volume_type"         => volume_type,
              "snapshot_id"         => nil,
              "attachments"         => [],
              "created_at"          => Fog::Rackspace::MockData.zulu_time,
              "availability_zone"   => "nova",
              "metadata"            => {},
            }
            if options[:snapshot_id]
              snapshot = self.data[:snapshots][snapshot_id]
              volume.merge!("size" => snapshot["size"])
            end

            self.data[:volumes][volume_id] = volume

            response(:body => {"volume" => volume})
          end
        end
      end
    end
  end
end
