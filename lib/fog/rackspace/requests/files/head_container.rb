module Fog
  module Rackspace
    module Files
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
          response = storage_request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => container,
            :query    => 'format=json'
          )
          response
        end

      end

      class Mock

        def head_container(container)
          raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
