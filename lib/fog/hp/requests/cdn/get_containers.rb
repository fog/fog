module Fog
  module CDN
    class HP
      class Real
        # List existing cdn-enabled storage containers
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'enabled_only'<~Boolean> - Set to true to limit results to cdn enabled containers
        #   * 'limit'<~Integer> - Upper limit to number of results returned
        #   * 'marker'<~String> - Only return objects with name greater than this value
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * container<~String>: Name of container
        def get_containers(options = {})
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
          data = self.data[:cdn_containers].map {|_,v| v}
          response.body = data
          response.status = 200
          response
        end
      end
    end
  end
end
