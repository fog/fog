module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Create volume
        #
        # @param [Integer] size size of volume in GB. Minimum size is 100
        # @param [Hash] options
        # @option options [String] :display_name display name for volume
        # @option options [String] :display_description display description for volume
        # @option options [String] :volume_type type of volume
        # @option options [String] :snapshot_id The optional snapshot from which to create a volume.
        # @option options [String] :image_id The ID of an image from the compute service. If provided, a bootable volume will be
        #    created.
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * 'volume' [Hash]:
        #       * 'volume_type' [String]: - type of volume
        #       * 'display_description' [String]: - volume description
        #       * 'metadata' [Hash]: - volume metadata
        #       * 'availability_zone'[String]: - region of the volume
        #       * 'status' [String]: - status of volume
        #       * 'id' [String]: - id of volume
        #       * 'attachments' [Array<Hash]: - array of hashes containing attachment information
        #       * 'size' [Fixnum]: - size of volume in GB (100 GB minimum)
        #       * 'snapshot_id' [String]: - The optional snapshot from which to create a volume.
        #       * 'display_name' [String]: - display name of volume
        #       * 'created_at' [String]: - the volume creation time
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/POST_createVolume__v1__tenant_id__volumes.html
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
          data['volume']['snapshot_id'] = options[:snapshot_id] unless options[:snapshot_id].nil?
          data['volume']['imageRef'] = options[:image_id] unless options[:image_id].nil?

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
            if snapshot_id = options[:snapshot_id]
              snapshot = self.data[:snapshots][snapshot_id]
              volume.merge!("size" => snapshot["size"])
            end
            volume["image_id"] = options[:image_id] if options[:image_id]

            self.data[:volumes][volume_id] = volume

            response(:body => {"volume" => volume})
          end
        end
      end
    end
  end
end
