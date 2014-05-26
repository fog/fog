module Fog
  module HP
    class BlockStorage
      class Real
        # Create a new block storage snapshot
        #
        # ==== Parameters
        # * name<~String>        - Name of the snapshot
        # * description<~String> - Description of the snapshot
        # * volume_id<~Integer>  - Id of the volume to create snapshot of
        # * options<~Hash>:
        #   * 'force'<~Boolean>  - Not implemented yet. True or False, to allow online snapshots (i.e. when volume is attached)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * snapshot<~Hash>:
        #       * 'id'<~Integer>: - Id for the snapshot
        #       * 'displayName'<~String>: - Name of the snapshot
        #       * 'displayDescription'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. "creating"
        #       * 'volumeId'<~Integer>: - Id of the volume from which the snapshot was created
        #       * 'createdAt'<~String>: - Timestamp in UTC when snapshot was created
        def create_snapshot(name, description, volume_id, options={})
          data = {
            'snapshot' => {
              'display_name'        => name,
              'display_description' => description,
              'volume_id'           => volume_id
            }
          }

          l_options = ['force']
          l_options.select{|o| options[o]}.each do |key|
            data['snapshot'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => "os-snapshots"
          )
        end
      end

      class Mock  # :nodoc:all
        def create_snapshot(name, description, volume_id, options={})
          response = Excon::Response.new
          if self.data[:volumes][volume_id]
            response.status = 200
            data = {
              'id'                 => Fog::Mock.random_numbers(3).to_i,
              'displayName'        => name,
              'displayDescription' => description,
              'size'               => self.data[:volumes][volume_id]['size'],
              'status'             => 'available',
              'volumeId'           => volume_id,
              'createdAt'          => Time.now.to_s
            }
            self.data[:snapshots][data['id']] = data
            response.body = { 'snapshot' => data }
          else
            raise Fog::HP::BlockStorage::NotFound
          end
          response
        end
      end
    end
  end
end
