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
            :path     => Fog::HP.escape(name),
            :query    => {'format' => 'json'}
          )
          response
        end
      end

      class Mock # :nodoc:all
        def head_container(name)
          response = Excon::Response.new
          headers = {}
          if data = self.data[:cdn_containers][name]
            data.each do |k,_|
              headers[k] = data[k] if data[k]
            end
            response.headers = headers
            response.status = 204
            response.body = ""
            response
          else
            raise Fog::CDN::HP::NotFound
          end
        end
      end
    end
  end
end
