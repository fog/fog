module Fog
  module HP
    class Storage
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
        def head_container(container)
          response = request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => URI.escape(container),
            :query    => {'format' => 'json'}
          )
          response
        end

      end

      class Mock # :nodoc:all

        def head_container(container_name)
          response = get_container(container_name)
          response.body = nil
          response
        end

      end

    end
  end
end
