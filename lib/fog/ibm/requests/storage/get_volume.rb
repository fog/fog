module Fog
  module Storage
    class IBM
      class Real

        # Get a volume
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def get_volume(volume_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/storage/#{volume_id}"
          )
        end

      end
    end
  end
end
