module Fog
  module CDN
    class HP
      class Real

        # enable CDN for a container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # # options<~Hash>:
        #   * 'X-CDN-Enabled'<~Boolean> - cdn status for container
        #   * 'X-CDN-URI'<~String> - cdn url for this container
        #   * 'X-TTL'<~String> - integer seconds before data expires, defaults to 86400 (1 day), in 900 (15 min.) to 1577836800 (50 years)
        #   * 'X-Log-Retention'<~Boolean> - ?
        def put_container(name, options = {})
          response = request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'PUT',
            :path     => Fog::HP.escape(name)
          )
          response
        end

      end

      class Mock # :nodoc:all
        def put_container(name, options = {})
          response = Excon::Response.new
          container_id = Fog::Mock.random_hex(33)
          data = {
            'x-cdn-ssl-uri' => "https://a111.cdn.net/cdn-test.net/#{container_id}/abc",
            'cdn_enabled'   => true,
            'name'          => name,
            'x-cdn-uri'     => "http://#{container_id}.cdn-test.net",
            'ttl'           => 86400,
            'log_retention' => false
          }
          response.headers = {
            "X-Cdn-Ssl-Uri" => "https://a111.cdn.net/cdn-test.net/#{container_id}/abc",
            "X-Cdn-Uri"     => "http://#{container_id}.cdn-test.net",
            "X-Trans-Id"    => Fog::Mock.random_hex(34)
          }
          response.status = 201
          response.body = "201 Created\n\n\n\n   "
          self.data[:cdn_containers][name] = data
          response
        end
      end

    end
  end
end
