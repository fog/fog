module Fog
  module CDN
    class HP
      class Real

        # modify CDN properties for a container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # # options<~Hash>:
        #   * 'X-CDN-Enabled'<~Boolean> - cdn status for container
        #   * 'X-CDN-URI'<~String> - cdn url for this container
        #   * 'X-TTL'<~String> - integer seconds before data expires, defaults to 86400 (1 day), in 900 (15 min.) to 1577836800 (50 years)
        #   * 'X-Log-Retention'<~Boolean> - ?
        def post_container(name, options = {})
          response = request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'POST',
            :path     => Fog::HP.escape(name)
          )
          response
        end

      end
    end
  end
end
