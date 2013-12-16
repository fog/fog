module Fog
  module Storage
    class Rackspace
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
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def get_containers(options = {})
          options = options.reject {|key, value| value.nil?}
          request(
            :expects  => [200, 204],
            :method   => 'GET',
            :path     => '',
            :query    => {'format' => 'json'}.merge!(options)
          )
        end

      end

      class Mock
        def get_containers(options = {})
          results = []
          data.each do |container, files|
            next if container == :meta

            total = files.keys.
              reject { |k| k == :meta }.
              inject(0) { |sum, k| sum + files[k].bytes }
            results << {
              "name" => container,
              "count" => files.size - 1,
              "bytes" => total
            }
          end
          response = Excon::Response.new
          response.status = 200
          response.body = results
          response
        end
      end

    end
  end
end
