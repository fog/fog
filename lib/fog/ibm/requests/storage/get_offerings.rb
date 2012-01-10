module Fog
  module Storage
    class IBM
      class Real

        # Get available storage offerings
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volumes<~Array>
        # TODO: docs
        def get_offerings
          options = {
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/storage'
          }
          request(options)
        end

      end
    end
  end
end
