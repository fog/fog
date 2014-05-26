module Fog
  module HP
    class BlockStorageV2
      class Real
        # Create a new block storage volume backup
        #
        # ==== Parameters
        # * 'volume_id'<~String> - UUId for the volume to backup
        # * options<~Hash>:
        #   * 'name'<~String> - Name of the volume backup
        #   * 'description'<~String> - Description of the volume backup
        #   * 'container'<~String> - The object storage container where the backup will be stored. Defaults to 'volumebackups', if not specified at creating time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * backup<~Hash>:
        #       * 'id'<~String> - UUId for the volume backup
        #       * 'name'<~String> - Name of the volume backup
        #       * 'links'<~Array> - array of volume backup links
        def create_volume_backup(volume_id, options={})
          data = {
            'backup' => {
              'volume_id' => volume_id
            }
          }

          l_options = ['name', 'description', 'container']
          l_options.select{|o| options[o]}.each do |key|
            data['backup'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => 'backups'
          )
        end
      end

      class Mock  # :nodoc:all
        def create_volume_backup(volume_id, options={})
          response = Excon::Response.new
          tenant_id = Fog::Mock.random_numbers(14).to_s
          id = Fog::HP::Mock.uuid.to_s

          if volume = self.data[:volumes][volume_id]
            data = {
              'id'                  => id,
              'status'              => 'available',
              'name'                => options['name'] || '',
              'description'         => options['description'] || '',
              'container'           => options['container'] || 'volumebackups',
              'availability_zone'   => volume['availability_zone'],
              'created_at'          => Time.now.to_s,
              'volume_id'           => volume_id,
              'size'                => volume['size'],
              'links'               => [{'href'=>"http://cinder:8776/v1/#{tenant_id}/backups/#{id}", 'rel'=>'self'}, {'href'=>"http://cinder:8776/v1/#{tenant_id}/backups/#{id}", 'rel'=>'bookmark'}],
              'fail_reason'         => '',
              'object_count'        => 1
            }
            resp_data = {
              'id'                  => id,
              'name'                => options['name'] || '',
              'links'               => [{'href'=>"http://cinder:8776/v1/#{tenant_id}/backups/#{id}", 'rel'=>'self'}, {'href'=>"http://cinder:8776/v1/#{tenant_id}/backups/#{id}", 'rel'=>'bookmark'}]
            }
            self.data[:volume_backups][data['id']] = data
            response.status = 202
            response.body = { 'backup' => resp_data }
            response
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
        end
      end
    end
  end
end
