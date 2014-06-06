module Fog
  module HP
    class BlockStorageV2
      class Real
        # Update an existing block storage volume
        #
        # ==== Parameters
        # * 'volume_id'<~String> - UUId of the volume to update
        # * options<~Hash>:
        #   * 'display_name'<~String>        - Name of the volume
        #   * 'display_description'<~String> - Description of the volume
        #   * 'metadata'<~Hash> - Up to 5 key value pairs containing 255 bytes of info
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volume<~Hash>:
        #       * 'id'<~String> - UUId for the volume
        #       * 'display_name'<~String> - Name of the volume
        #       * 'display_description'<~String> - Description of the volume
        #       * 'size'<~Integer> - Size in GB for the volume
        #       * 'status'<~String> - Status of the volume i.e. "creating"
        #       * 'volume_type'<~String> - Type of the volume
        #       * 'snapshot_id'<~String> - UUId of the snapshot, the volume was created from.
        #       * 'source_volid'<~String> - UUId of a volume, the volume was created from.
        #       * 'created_at'<~String> - Timestamp in UTC when volume was created
        #       * 'availability_zone'<~String> - Availability zone i.e. "az1"
        #       * attachments<~Array>: Array of hashes of attachments
        #       * metadata<~Hash>: Hash of metadata for the volume
        def update_volume(volume_id, options={})
          data = {
            'volume' => {}
          }

          l_options = ['display_name', 'display_description', 'metadata']
          l_options.select{|o| options[o]}.each do |key|
            data['volume'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "volumes/#{volume_id}"
          )
        end
      end

      class Mock  # :nodoc:all
        def update_volume(volume_id, options={})
          response = Excon::Response.new
          if volume = self.data[:volumes][volume_id]
            response.status = 200
            volume['display_name'] = options['display_name'] if options['display_name']
            volume['display_description'] = options['display_description'] if options['display_description']
            volume['metadata'] = options['metadata'] if options['metadata']
            response.body = { 'volume' => volume }
            response
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
        end
      end
    end
  end
end
