module Fog
  module Compute
    class IBM
      class Real

        # Returns the list of Images available to be provisioned on the IBM DeveloperCloud.
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'locations'<~Array>: list of locations
        def list_locations
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/locations"
          )
        end

      end

      class Mock

        def list_locations
          response = Excon::Response.new
          response.status = 200
          response.body = { "locations" => self.data[:locations].values }
          response
        end

      end
    end
  end
end
