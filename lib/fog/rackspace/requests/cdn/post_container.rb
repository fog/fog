module Fog
  module CDN
    class Rackspace
      class Real
        # modify CDN properties for a container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # * options<~Hash>:
        #   * 'X-CDN-Enabled'<~Boolean> - cdn status for container
        #   * 'X-CDN-URI'<~String> - cdn url for this container
        #   * 'X-TTL'<~String> - integer seconds before data expires, defaults to 86400 (1 day), in 3600..259200
        #   * 'X-Log-Retention'<~Boolean> - ?
        #   * 'X-User-Agent-ACL'<~String> - ?
        #   * 'X-Referrer-ACL'<~String> - ?
        # @return [Excon::Response] response
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def post_container(name, options = {})
          response = request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'POST',
            :path     => CGI.escape(name)
          )
          response
        end
      end

      class Mock
        def post_container(name, options = {})
          raise Fog::Storage::Rackspace::NotFound.new "#{name} not found" unless name == 'fogcontainertests'
          response = Excon::Response.new
          response.status = 202
          response.headers = {
            "X-Cdn-Uri"=>"http://e4bbc22477d80eaf22bd-ca4e4e61e477bbd430e1f5b9dc9a19f5.r53.cf1.rackcdn.com",
            "X-Cdn-Ios-Uri"=>"http://3c10ef49037f74416445-ca4e4e61e477bbd430e1f5b9dc9a19f5.iosr.cf1.rackcdn.com",
            "X-Cdn-Ssl-Uri"=>"https://b722b8ee248259c37901-ca4e4e61e477bbd430e1f5b9dc9a19f5.ssl.cf1.rackcdn.com",
            "Content-Length"=>"58", "Date"=>"Fri, 01 Feb 2013 21:31:30 GMT",
            "Content-Type"=>"text/plain; charset=UTF-8",
            "X-Cdn-Streaming-Uri"=>"http://b82027c64cb4dd03670a-ca4e4e61e477bbd430e1f5b9dc9a19f5.r53.stream.cf1.rackcdn.com",
            "X-Trans-Id"=>"tx4a3206e63dfc446bb5b60e34a62f749d"
          }
          response.body = "202 Accepted\n\nThe request is accepted for processing.\n\n   "
          response
        end
      end
    end
  end
end
