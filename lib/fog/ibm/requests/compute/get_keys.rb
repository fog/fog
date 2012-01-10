module Fog
  module Compute
    class IBM
      class Real

        # Get keys
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * images<~Array>
        # TODO: docs
        def get_keys
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/keys'
          )
        end

      end
    end
  end
end
