module Fog
  module Compute
    class IBM
      class Real

        # Returns address offerings
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO: doc
        def list_address_offerings
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => '/offerings/address'
          )
        end

      end
    end
  end
end
