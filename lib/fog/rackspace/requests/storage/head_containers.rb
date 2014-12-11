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

      class Mock
        def head_containers
          bytes_used = data.values.map { |c| c.bytes_used }.reduce(0) { |a, b| a + b }
          container_count = data.size
          object_count = data.values.map { |c| c.objects.size }.reduce(0) { |a, b| a + b }

          response = Excon::Response.new
          response.status = 204
          response.headers = {
            'X-Account-Bytes-Used' => bytes_used,
            'X-Account-Container-Count' => container_count,
            'X-Account-Object-Count' => object_count
          }.merge(account_meta)
          response
        end
      end
    end
  end
end
