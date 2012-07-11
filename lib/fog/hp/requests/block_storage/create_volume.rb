module Fog
  module BlockStorage
    class HP
      class Real

        # Create a new block storage volume
        #
        # ==== Parameters
        # * name<~String>        - Name of the volume
        # * description<~String> - Description of the volume
        # * size<~Integer>       - Size of the volume (in GBs)
        # * options<~Hash>:
        #   * 'snapshot_id'<~String> - Id of the volume snapshot
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volume<~Hash>:
        #       * 'id'<~Integer>: - Id for the volume
        #       * 'displayName'<~String>: - Name of the volume
        #       * 'displayDescription'<~String>: - Description of the volume
        #       * 'size'<~Integer>: - Size in GB for the volume
        #       * 'status'<~String>: - Status of the volume i.e. "creating"
        #       * 'volumeType'<~String>: - Type of the volume
        #       * 'snapshotId'<~String>: - Id of the volume snapshot
        #       * 'createdAt'<~String>: - Timestamp in UTC when volume was created
        #       * 'availabilityZone'<~String>: - Availability zone i.e. "nova"
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

          l_options = ['snapshot_id', 'metadata']  # TODO: add attachments later
          l_options.select{|o| options[o]}.each do |key|
            data['volume'][key] = options[key]
          end

          request(
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => "os-volumes"
          )
        end

      end

      class Mock  # :nodoc:all

        def create_volume(name, description, size, options={})
          response = Excon::Response.new
          response.status = 200
          data = {
            'id'                 => Fog::Mock.random_numbers(3).to_i,
            'displayName'        => name,
            'displayDescription' => description,
            'size'               => size,
            'status'             => 'available',
            'snapshotId'         => options['snapshot_id'] || "",
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