module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Create a snapshot from a volume
        #
        # @param [String] volume_id Id of server to create image from
        # @param [Hash] options
        # @option options [String] :display_name display name for snapshot
        # @option options [String] :display_description display description for snapshot
        # @option options [Boolean] :force Set to true to force service to create snapshot
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * 'snapshot' [Hash]:
        #       * 'volume_id' [String]: - the volume_id of the snapshot
        #         * 'display_description' [String]: - display description of snapshot
        #         * 'status' [String]: - status of snapshot
        #         * 'id' [String]: - id of snapshot
        #         * 'size' [Fixnum]: - size of the snapshot in GB
        #         * 'display_name' [String]: - display name of snapshot
        #         * 'created_at' [String]: - creation time of snapshot
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @note All writes to the volume should be flushed before creating the snapshot, either by un-mounting any file systems on the volume or by detaching the volume.
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/POST_createSnapshot__v1__tenant_id__snapshots.html
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
