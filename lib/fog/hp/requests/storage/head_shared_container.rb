module Fog
  module Storage
    class HP
      class Real
        # List number of objects and total bytes stored for a shared container
        #
        # ==== Parameters
        # * shared_container_url<~String> - Url of the shared container
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Container-Object-Count'<~String> - Count of containers
        #     * 'X-Container-Bytes-Used'<~String>   - Bytes used
        def head_shared_container(shared_container_url)
          # split up the shared container url
          uri = URI.parse(shared_container_url)
          path   = uri.path

          response = shared_request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => path,
            :query    => {'format' => 'json'}
          )
          response
        end
      end

      class Mock # :nodoc:all
        def head_shared_container(shared_container_url)
          response = get_shared_container(shared_container_url)
          response.body = nil
          response.status = 204
          response
        end
      end
    end
  end
end
