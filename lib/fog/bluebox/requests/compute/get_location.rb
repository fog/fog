module Fog
  module Compute
    class Bluebox
      class Real

        # Get details of a location
        #
        # ==== Parameters
        # * location_id<~Integer> - Id of location to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO
        def get_location(location_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/locations/#{location_id}.json"
          )
        end

      end
    end
  end
end
