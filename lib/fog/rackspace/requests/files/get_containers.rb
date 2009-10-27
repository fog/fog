unless Fog.mocking?

  module Fog
    module Rackspace
      class Files

        # List existing storage containers
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'limit'<~Integer> - Upper limit to number of results returned
        #   * 'marker'<~String> - Only return objects with name greater than this value
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Array>:
        #     * container<~Hash>:
        #       * 'bytes'<~Integer>: - Number of bytes used by container
        #       * 'count'<~Integer>: - Number of items in container
        #       * 'name'<~String>: - Name of container
        def get_containers(options = {})
          options = { 'format' => 'json' }.merge!(options)
          query = []
          for key, value in options
            query << "#{key}=#{CGI.escape(value)}&"
          end
          query.chop!
          response = storage_request(
            :expects  => [200, 204],
            :method   => 'GET',
            :path     => '',
            :query    => query
          )
          if response.status == 204
            response.body = []
          end
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
