module Fog
  module Storage
    class IBM
      class Real

        # Deletes the storage that the authenticated user manages with the specified :storage_id
        #
        # ==== Parameters
        # * volume_id<~String> - Id of storage volume
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     *'success'<~Bool>: true or false for success
        def delete_volume(volume_id)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/storage/#{volume_id}"
          )
        end

      end

      class Mock

        def delete_volume(volume_id)
          response = Excon::Response.new
          if volume_exists? volume_id
            self.data[:volumes].delete volume_id
            response.status = 200
            response.body = {"success"=>true}
          else
            response.status = 404
          end
          response
        end

      end
    end
  end
end
