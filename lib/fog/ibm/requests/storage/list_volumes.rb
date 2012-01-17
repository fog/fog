module Fog
  module Storage
    class IBM
      class Real

        # Get existing volumes
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volumes<~Array>
        # TODO: docs
        def list_volumes
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/storage'
          )
        end

      end
    end
  end
end
