module Fog
  module HP
    class BlockStorage
      class Real
        # Create a new block storage volume
        #
        # ==== Parameters
        # * name<~String>        - Name of the volume
        # * description<~String> - Description of the volume
        # * size<~Integer>       - Size of the volume (in GBs)
        # * options<~Hash>:
        #   * 'snapshot_id'<~String> - Id of the volume snapshot to create the volume from. The request is invalid if both the snapshot_id and the imageRef parameters are specified and are not null.
        #   * 'imageRef'<~String> - Id of the image to create the volume from. This creates a bootable volume. The request is invalid if both the snapshot_id and the imageRef parameters are specified and are not null.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volume<~Hash>:
        #       * 'id'<~Integer> - Id for the volume
        #       * 'displayName'<~String> - Name of the volume
        #       * 'displayDescription'<~String> - Description of the volume
        #       * 'size'<~Integer> - Size in GB for the volume
        #       * 'status'<~String> - Status of the volume i.e. "creating"
        #       * 'volumeType'<~String> - Type of the volume
        #       * 'snapshotId'<~String> - Id of the snapshot, the volume was created from.
        #       * 'imageRef'<~String> - Id of the image, the volume was created from. A not null value means it is a bootable volume.
        #       * 'createdAt'<~String> - Timestamp in UTC when volume was created
        #       * 'availabilityZone'<~String> - Availability zone i.e. "nova"
        #       * attachments<~Array>: Array of hashes of attachments
        #       * metadata<~Hash>: Hash of metadata for the volume
        def create_volume(name, description, size, options={})
          data = {
            'volume' => {
              'display_name'        => name,
              'display_description' => description,
              'size'                => size
            }
          }

          l_options = ['snapshot_id', 'imageRef', 'metadata']
          l_options.select{|o| options[o]}.each do |key|
            data['volume'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => "os-volumes"
          )
        end
      end

      class Mock  # :nodoc:all
        def create_volume(name, description, size, options={})
          if options['snapshotId'] && options['imageRef']
            raise Fog::Errors::BadRequest.new("Snapshot and image cannot be specified together.")
          else
            response = Excon::Response.new
            response.status = 200
            data = {
              'id'                 => Fog::Mock.random_numbers(3).to_i,
              'displayName'        => name,
              'displayDescription' => description,
              'size'               => size,
              'status'             => 'available',
              'snapshotId'         => options['snapshot_id'] || "",
              #'imageRef'           => options['imageRef'] || "", # TODO: not implemented to preserve backward compatibility
              'volumeType'         => nil,
              'availabilityZone'   => 'nova',
              'createdAt'          => Time.now.to_s,
              'metadata'           => options['metadata'] || {},
              'attachments'        => [{}]
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
