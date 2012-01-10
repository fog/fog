module Fog
  module Compute
    class IBM
      class Real

        # Get addresses
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * instances<~Array>:
        # TODO: docs
        def get_addresses
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/addresses'
          )
        end

      end
    end
  end
end
