unless Fog.mocking?

  module Fog
    module Rackspace
      class Files

        # List number of containers and total bytes stored
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Account-Container-Count'<~String> - Count of containers
        #     * 'X-Account-Bytes-Used'<~String> - Bytes used
        def head_containers
          response = storage_request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => '',
            :query    => 'format=json'
          )
          response
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def head_containers
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end

end
