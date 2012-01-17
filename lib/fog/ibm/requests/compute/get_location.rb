module Fog
  module Compute
    class IBM
      class Real

        # Get a location
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def get_location(location_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/locations/#{location_id}"
          )
        end

      end
    end
  end
end
