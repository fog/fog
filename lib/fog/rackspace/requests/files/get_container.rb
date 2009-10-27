unless Fog.mocking?

  module Fog
    module Rackspace
      class Files

        # List number of containers and total bytes stored
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
        # * response<~Fog::AWS::Response>:
        #   * headers<~Hash>:
        #     * 'X-Account-Container-Count'<~String> - Count of containers
        #     * 'X-Account-Bytes-Used'<~String> - Bytes used
        def get_container(container, options = {})
          query = ''
          for key, value in options.merge!({ 'format' => 'json' })
            query << "#{key}=#{value}&"
          end
          query.chop!
          response = storage_request(
            :expects  => 200,
            :method   => 'GET',
            :path     => container,
            :query    => query
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

        def get_flavors
        end

      end
    end
  end

end
