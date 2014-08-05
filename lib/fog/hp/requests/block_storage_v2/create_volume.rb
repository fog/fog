module Fog
  module HP
    class BlockStorageV2
      class Real
        # Create a new block storage volume
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'display_name'<~String> - Name of the volume
        #   * 'display_description'<~String> - Description of the volume
        #   * 'size'<~Integer> - Size of the volume (in GBs). Size is optional only if 'snapshot_id' is specified.
        #   * 'snapshot_id'<~String> - UUId of the volume snapshot to create the volume from. The snapshot_id, imageRef and the source_volid parameters are mutually exclusive, and only one should be specified in the request.
        #   * 'imageRef'<~String> - UUId of the image to create the volume from. This creates a bootable volume. The snapshot_id, imageRef and the source_volid parameters are mutually exclusive, and only one should be specified in the request.
        #   * 'source_volid'<~String> - UUId of an 'available' volume to create the volume from. The request is invalid if the volume is not available. The snapshot_id, imageRef and the source_volid parameters are mutually exclusive, and only one should be specified in the request.
        #   * 'availability_zone'<~String> - Availability zone where the volume should be created. Defaults to 'az1'.
        #   * 'volume_type'<~String> - Type of the volume
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
        def create_volume(options={})
          data = {
            'volume' => {}
          }

          l_options = ['display_name', 'display_description', 'size',
                       'snapshot_id', 'imageRef', 'source_volid',
                       'availability_zone', 'volume_type', 'metadata']
          l_options.select{|o| options[o]}.each do |key|
            data['volume'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'volumes'
          )
        end
      end

      class Mock  # :nodoc:all
        def create_volume(options={})
          if options['snapshot_id'] && options['imageRef'] && options['source_volid']
            raise Fog::Errors::BadRequest.new('The snapshot_id, imageRef and the source_volid parameters are mutually exclusive, and only one should be specified in the request.')
          else
            response = Excon::Response.new
            response.status = 200
            data = {
              'id'                  => Fog::HP::Mock.uuid.to_s,
              'status'              => 'available',
              'display_name'        => options['display_name'] || '',
              'attachments'         => [{}],
              'availability_zone'   => options['availability_zone'] || 'az1',
              'bootable'            => false,
              'created_at'          => Time.now.to_s,
              'display_description' => options['display_description'] || '',
              'volume_type'         => 'None',
              'snapshot_id'         => options['snapshot_id'] || '',
              'source_volid'        => options['source_volid'] || '',
              'metadata'            => options['metadata'] || {},
              'size'                => options['size']
            }
            self.data[:volumes][data['id']] = data
            response.body = { 'volume' => data }
            response
          end
        end
      end
    end
  end
end
