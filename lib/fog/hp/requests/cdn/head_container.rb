module Fog
  module CDN
    class HP
      class Real

        # List cdn properties for a container
        #
        # ==== Parameters
        # * name<~String> - Name of container to retrieve info for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Cdn-Enabled'<~Boolean> - cdn status for container
        #     * 'X-Cdn-Uri'<~String> - cdn url for this container
        #     * 'X-Ttl'<~String> - integer seconds before data expires, defaults to 86400 (1 day)
        #     * 'X-Log-Retention'<~Boolean> - ?
        def head_container(name)
          response = request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => escape_name(name),
            :query    => {'format' => 'json'}
          )
          response
        end

      end
    end
  end
end
