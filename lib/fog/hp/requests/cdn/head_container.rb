module Fog
  module CDN
    class HP
      class Real

        # List cdn properties for a container
        #
        # ==== Parameters
        # * container<~String> - Name of container to retrieve info for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Cdn-Enabled'<~Boolean> - cdn status for container
        #     * 'X-Cdn-Uri'<~String> - cdn url for this container
        #     * 'X-Ttl'<~String> - integer seconds before data expires, defaults to 86400 (1 day)
        #     * 'X-Log-Retention'<~Boolean> - ?
        def head_container(container)
          response = request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => container,
            :query    => {'format' => 'json'}
          )
          response
        end

      end
    end
  end
end
