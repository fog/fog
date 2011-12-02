module Fog
  module Storage
    class IBM
      class Real

        # Get existing volumes
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volumes<~Array>
        # TODO: docs
        def list_volumes
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/storage'
          )
        end

      end

      class Mock

        def list_volumes
          response = Excon::Response.new
          response.status = 200
          response.body = { 'volumes' => format_list_volumes_response }
          response
        end

      end
    end
  end
end
