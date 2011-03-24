module Fog
  module Rackspace
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
    end
  end
end
