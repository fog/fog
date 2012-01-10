module Fog
  module Storage
    class IBM
      class Real

        # Delete a volume
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def delete_volume(volume_id)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/storage/#{volume_id}"
          )
        end

      end
    end
  end
end
