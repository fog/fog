module Fog
  module Storage
    class HP
      class Real
        # Get details for container and total bytes stored
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
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Account-Container-Count'<~String> - Count of containers
        #     * 'X-Account-Bytes-Used'<~String> - Bytes used
        #   * body<~Array>:
        #     * 'bytes'<~Integer> - Number of bytes used by container
        #     * 'count'<~Integer> - Number of items in container
        #     * 'name'<~String> - Name of container
        #     * item<~Hash>:
        #       * 'bytes'<~String> - Size of object
        #       * 'content_type'<~String> Content-Type of object
        #       * 'hash'<~String> - Hash of object (etag?)
        #       * 'last_modified'<~String> - Last modified timestamp
        #       * 'name'<~String> - Name of object
        def get_container(container, options = {})
          options = options.reject {|key, value| value.nil?}
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => Fog::HP.escape(container),
            :query    => {'format' => 'json'}.merge!(options)
          )
          response
        end
      end

      class Mock # :nodoc:all
        def get_container(container_name, options = {})
          unless container_name
            raise ArgumentError.new('container_name is required')
          end
          if options['delimiter']
            Fog::Mock.not_implemented
          end
          response = Excon::Response.new
          obj_count = 0
          obj_total_bytes = 0
          if container = self.data[:containers][container_name]
            contents = container[:objects].values.sort {|x,y| x['Key'] <=> y['Key']}.reject do |object|
                (options['prefix'] && object['Key'][0...options['prefix'].length] != options['prefix']) ||
                (options['marker'] && object['Key'] <= options['marker'])
              end.map do |object|
                obj_count = obj_count + 1
                obj_total_bytes = obj_total_bytes + object['Content-Length'].to_i
                data = {
                  'name'          => object['Key'],
                  'hash'          => object['ETag'],
                  'bytes'         => object['Content-Length'].to_i,
                  'content_type'  => object['Content-Type'],
                  'last_modified' => Time.parse(object['Date'])
                }
              data
            end

            response.status = 200
            response.body = contents
            response.headers = {
              'X-Container-Object-Count' => obj_count,
              'X-Container-Bytes-Used'   => obj_total_bytes,
              'Accept-Ranges'            => 'bytes',
              'Content-Type'             => container['Content-Type'],
              'Content-Length'           => container['Content-Length']
            }
            response
          else
            raise Fog::Storage::HP::NotFound
          end
        end
      end
    end
  end
end
