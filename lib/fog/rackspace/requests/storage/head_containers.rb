module Fog
  module Storage
    class Rackspace
      class Real

        # List number of containers and total bytes stored
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Account-Container-Count'<~String> - Count of containers
        #     * 'X-Account-Bytes-Used'<~String> - Bytes used
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def head_containers
          request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => '',
            :query    => {'format' => 'json'}
          )
        end

      end
    end
  end
end
