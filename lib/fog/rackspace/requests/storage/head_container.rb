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
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        def head_container(container)
          request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => Fog::Rackspace.escape(container),
            :query    => {'format' => 'json'}
          )
        end

      end
    end
  end
end
