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
        def list_offerings
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/storage'
          )
        end

      end
    end
  end
end
