module Fog
  module Storage
    class HP
      class Real
        # List number of containers and total bytes stored
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Account-Container-Count'<~String> - Count of containers
        #     * 'X-Account-Bytes-Used'<~String> - Bytes used
        def head_containers
          response = request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => '',
            :query    => {'format' => 'json'}
          )
          response
        end
      end

      class Mock # :nodoc:all
        def head_containers
          response = get_containers
          response.body = nil
          response
        end
      end
    end
  end
end
