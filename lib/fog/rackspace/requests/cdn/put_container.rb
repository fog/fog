module Fog
  module CDN
    class Rackspace
      class Real
        # enable CDN for a container
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
        def put_container(name, options = {})
          response = request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'PUT',
            :path     => CGI.escape(name)
          )
          response
        end
      end

      class Mock
        def put_container(name, options = {})
          response = Excon::Response.new
          response.status = 201
          response.headers = {
            "X-Cdn-Uri"=>"http://e4bbc22477d80eaf22bd-ca4e4e61e477bbd430e1f5b9dc9a19f5.r53.cf1.rackcdn.com",
            "X-Cdn-Ios-Uri"=>"http://3c10ef49037f74416445-ca4e4e61e477bbd430e1f5b9dc9a19f5.iosr.cf1.rackcdn.com",
            "X-Cdn-Ssl-Uri"=>"https://b722b8ee248259c37901-ca4e4e61e477bbd430e1f5b9dc9a19f5.ssl.cf1.rackcdn.com",
            "Content-Length"=>"18",
            "Date"=>"Fri, 01 Feb 2013 21:21:45 GMT",
            "Content-Type"=>"text/plain; charset=UTF-8",
            "X-Cdn-Streaming-Uri"=>"http://b82027c64cb4dd03670a-ca4e4e61e477bbd430e1f5b9dc9a19f5.r53.stream.cf1.rackcdn.com",
            "X-Trans-Id"=>"tx1b41ec63189f4862baa65e0c08711772"
          }
          response.body = "201 Created\n\n\n\n   "
          response
        end
      end
    end
  end
end
