module Fog
  module Storage
    class Rackspace
      class Real
        # List number of objects and total bytes stored
        #
        # ==== Parameters
        # * container<~String> - Name of container to retrieve info for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Container-Object-Count'<~String> - Count of containers
        #     * 'X-Container-Bytes-Used'<~String>   - Bytes used
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def head_container(container)
          request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => Fog::Rackspace.escape(container),
            :query    => {'format' => 'json'}
          )
        end
      end

      class Mock
        def head_container(container)
          c = mock_container! container

          response = Excon::Response.new
          response.status = 204
          response.headers = c.to_headers
          response
        end
      end
    end
  end
end
