module Fog
  module Storage
    class Rackspace
      class Real
        # Get details for container and total bytes stored
        #
        # ==== Parameters
        # * container<~String> - Name of container to retrieve info for
        # * options<~String>:
        #   * 'limit'<~String> - Maximum number of objects to return
        #   * 'marker'<~String> - Only return objects whose name is greater than marker
        #   * 'prefix'<~String> - Limits results to those starting with prefix
        #   * 'path'<~String> - Return objects nested in the pseudo path
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Account-Container-Count'<~String> - Count of containers
        #     * 'X-Account-Bytes-Used'<~String> - Bytes used
        #   * body<~Array>:
        #     * 'bytes'<~Integer> - Number of bytes used by container
        #     * 'count'<~Integer> - Number of items in container
        #     * 'name'<~String> - Name of container
        #     * item<~Hash>:
        #       * 'bytes'<~String> - Size of object
        #       * 'content_type'<~String> Content-Type of object
        #       * 'hash'<~String> - Hash of object (etag?)
        #       * 'last_modified'<~String> - Last modified timestamp
        #       * 'name'<~String> - Name of object
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def get_container(container, options = {})
          options = options.reject {|key, value| value.nil?}
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => Fog::Rackspace.escape(container),
            :query    => {'format' => 'json'}.merge!(options)
          )
        end
      end

      class Mock
        def get_container(container, options = {})
          c = mock_container! container

          results = []
          c.objects.each do |key, mock_file|
            results << {
              "hash" => mock_file.hash,
              "last_modified" => mock_file.last_modified.strftime('%Y-%m-%dT%H:%M:%S.%L'),
              "bytes" => mock_file.bytes_used,
              "name" => key,
              "content_type" => mock_file.content_type
            }
          end

          response = Excon::Response.new
          response.status = 200
          response.headers = c.to_headers
          response.body = results
          response
        end
      end
    end
  end
end
