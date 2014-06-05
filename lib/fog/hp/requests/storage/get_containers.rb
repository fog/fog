module Fog
  module Storage
    class HP
      class Real
        # List existing storage containers
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'limit'<~Integer> - Upper limit to number of results returned
        #   * 'marker'<~String> - Only return objects with name greater than this value
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * container<~Hash>:
        #       * 'bytes'<~Integer>: - Number of bytes used by container
        #       * 'count'<~Integer>: - Number of items in container
        #       * 'name'<~String>: - Name of container
        def get_containers(options = {})
          options = options.reject {|key, value| value.nil?}
          response = request(
            :expects  => [200, 204],
            :method   => 'GET',
            :path     => '',
            :query    => {'format' => 'json'}.merge!(options)
          )
          response
        end
      end

      class Mock # :nodoc:all
        def get_containers(options = {})
          response = Excon::Response.new
          acc_cont_count = 0
          acc_obj_count = 0
          acc_obj_bytes = 0
          containers = self.data[:containers].map do |key, container|
            acc_cont_count = acc_cont_count + 1
            obj_count = 0
            container[:objects].values.map do |object|
              acc_obj_count = acc_obj_count + 1
              acc_obj_bytes = acc_obj_bytes + object['Content-Length'].to_i
              obj_count = obj_count + 1
              container['Object-Count'] = obj_count
            end
            data = {
              'name'  => key,
              'count' => container['Object-Count'].to_i,
              'bytes' => container['Content-Length'].to_i
            }
            data
          end
          response.body = containers
          response.headers = {
            'X-Account-Object-Count'    => acc_obj_count,
            'X-Account-Bytes-Used'      => acc_obj_bytes,
            'X-Account-Container-Count' => acc_cont_count,
            'Accept-Ranges'             => 'bytes'
          }
          response.status = 200
          response
        end
      end
    end
  end
end
