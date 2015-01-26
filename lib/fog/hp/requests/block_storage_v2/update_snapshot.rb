module Fog
  module HP
    class BlockStorageV2
      class Real
        # Update an existing block storage snapshot
        #
        # ==== Parameters
        # * 'snapshot_id'<~String> - UUId of the snapshot to update
        # * options<~Hash>:
        #   * 'display_name'<~String>        - Name of the snapshot
        #   * 'display_description'<~String> - Description of the snapshot
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * snapshot<~Hash>:
        #       * 'id'<~String>: - UUId for the snapshot
        #       * 'display_name'<~String>: - Name of the snapshot
        #       * 'display_description'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. "available"
        #       * 'volume_id'<~String>: - UUId of the volume from which the snapshot was created
        #       * 'created_at'<~String>: - Timestamp in UTC when volume was created
        #       * metadata<~Hash>: Hash of metadata for the snapshot
        def update_snapshot(snapshot_id, options={})
          data = {
            'snapshot' => {}
          }

          l_options = ['display_name', 'display_description', 'metadata']
          l_options.select{|o| options[o]}.each do |key|
            data['snapshot'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock  # :nodoc:all
        def update_snapshot(snapshot_id, options={})
          unless snapshot_id
            raise ArgumentError.new('snapshot_id is required')
          end
          response = Excon::Response.new
          if snapshot = self.data[:snapshots][snapshot_id]
            response.status = 200
            snapshot['display_name'] = options['display_name'] if options['display_name']
            snapshot['display_description'] = options['display_description'] if options['display_description']
            snapshot['metadata'] = options['metadata'] if options['metadata']
            response.body = { 'snapshot' => snapshot }
            response
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
        end
      end
    end
  end
end
