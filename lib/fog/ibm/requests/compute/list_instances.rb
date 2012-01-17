module Fog
  module Compute
    class IBM
      class Real

        # Get instances
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * instances<~Array>:
        # TODO: docs
        def list_instances
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/instances'
          )
        end

      end

      class Mock

        def list_instances
          response = Excon::Response.new
          response.status = 200
          response.body = { 'instances' => [] }
          response
        end

      end
    end
  end
end
