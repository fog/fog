module Fog
  module Storage
    class HP
      class Real

        # Get details for a shared container
        #
        # ==== Parameters
        # * shared_container_url<~String> - Url of the shared container
        # * options<~String>:
        #   * 'limit'<~String> - Maximum number of objects to return
        #   * 'marker'<~String> - Only return objects whose name is greater than marker
        #   * 'prefix'<~String> - Limits results to those starting with prefix
        #   * 'path'<~String> - Return objects nested in the pseudo path
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Container-Object-Count'<~String> - Count of objects in container
        #     * 'X-Container-Bytes-Used'<~String> - Bytes used
        #     * 'X-Trans-Id'<~String> - Trans Id
        #   * body<~Array>:
        #     * item<~Hash>:
        #       * 'bytes'<~String> - Size of object
        #       * 'content_type'<~String> Content-Type of object
        #       * 'hash'<~String> - Hash of object (etag?)
        #       * 'last_modified'<~String> - Last modified timestamp
        #       * 'name'<~String> - Name of object
        def get_shared_container(shared_container_url, options = {})
          options = options.reject {|key, value| value.nil?}
          # split up the shared container url
          uri = URI.parse(shared_container_url)
          path   = uri.path

          response = shared_request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path,
            :query    => {'format' => 'json'}.merge!(options)
          )
          response
        end

      end

      class Mock # :nodoc:all

        def get_shared_container(shared_container_url, options = {})

        end

      end

    end
  end
end
