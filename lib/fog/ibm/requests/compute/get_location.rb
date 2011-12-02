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

      class Mock

        def get_location(location_id)
          response = Excon::Response.new
          if location_exists? location_id
            response.status = 200
            response.body   = self.data[:locations][location_id]
          else
            response.status = 404
          end
          response
        end

        def location_exists?(location_id)
          self.data[:locations].key? location_id
        end

      end
    end
  end
end
