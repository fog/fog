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
        def get_volumes
          options = {
            :method   => 'GET',
            :expects  => 200,
            :path     => '/storage'
          }
          request(options)
        end

      end
    end
  end
end
