module Fog
  module Compute
    class IBM
      class Real

        # Get all locations
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def list_locations
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/locations"
          )
        end

      end
    end
  end
end
