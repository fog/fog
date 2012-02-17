module Fog
  module Compute
    class Bluebox
      class Real

        # Get list of locations
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'id'<~String> - UUID of the location
        #     * 'description'<~String> - Description of the location
        def get_locations
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'api/locations.json'
          )
        end

      end
    end
  end
end
