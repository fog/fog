module Fog
  module HP
    class BlockStorageV2
      class Real
        # Create a new block storage snapshot
        # The snapshot is created in the same availability_zone as the specified volume
        #
        # ==== Parameters
        # * 'volume_id'<~String>  - UUId of the volume to create the snapshot from
        # * options<~Hash>:
        #   * 'display_name'<~String>        - Name of the snapshot
        #   * 'display_description'<~String> - Description of the snapshot
        #   * 'force'<~Boolean>  - true or false, defaults to false. It allows online snapshots (i.e. when volume is attached)
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
        def create_snapshot(volume_id, options={})
          data = {
            'snapshot' => {
              'volume_id'  => volume_id
            }
          }

          l_options = ['display_name', 'display_description', 'force']
          l_options.select{|o| options[o]}.each do |key|
            data['snapshot'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'snapshots'
          )
        end
      end

      class Mock  # :nodoc:all
        def create_snapshot(volume_id, options={})
          response = Excon::Response.new
          if self.data[:volumes][volume_id]
            response.status = 200
            data = {
              'id'                  => Fog::HP::Mock.uuid.to_s,
              'display_name'        => options['display_name'] || '',
              'display_description' => options['display_description'] || '',
              'size'                => self.data[:volumes][volume_id]['size'],
              'status'              => 'available',
              'volume_id'           => volume_id,
              'created_at'          => Time.now.to_s
            }
            self.data[:snapshots][data['id']] = data
            response.body = { 'snapshot' => data }
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
          response
        end
      end
    end
  end
end
