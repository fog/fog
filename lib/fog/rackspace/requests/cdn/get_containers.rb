module Fog
  module CDN
    class Rackspace
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
        # @return [Excon::Response] response
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
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

      class Mock
        def get_containers(options = {})
          response = Excon::Response.new
          response.status = 200
          response.headers = {
            "Content-Length"=>"4402",
            "Date"=>"Fri, 01 Feb 2013 21:16:54 GMT",
            "Content-Type"=>"application/json",
            "X-Trans-Id"=>"tx6c79ea47300941c49f2291b4d47d4ef5"
          }
          response.body = [
            { "log_retention"=>false,
              "cdn_ios_uri"=>"http://a590286a323fec6aed22-d1e9259b2132e81da48ed3e1e802ef22.iosr.cf1.rackcdn.com",
              "ttl"=>3600,
              "cdn_enabled"=>true,
              "cdn_streaming_uri"=>"http://168e307d41afe64f1a62-d1e9259b2132e81da48ed3e1e802ef22.r2.stream.cf1.rackcdn.com",
              "name"=>"brown", "cdn_uri"=>"http://6e8f4bf5125c9c2e4e3a-d1e9259b2132e81da48ed3e1e802ef22.r2.cf1.rackcdn.com",
              "cdn_ssl_uri"=>"https://f83cb7d39e0b9ff9581b-d1e9259b2132e81da48ed3e1e802ef22.ssl.cf1.rackcdn.com"
            },
            { "log_retention"=>false,
              "cdn_ios_uri"=>"http://b141f80caedd02158f10-cf33674d895dc8b8e6e5207fdbd5cae4.iosr.cf1.rackcdn.com",
              "ttl"=>5000,
              "cdn_enabled"=>false,
              "cdn_streaming_uri"=>"http://ea5feee96b8087a3d5e5-cf33674d895dc8b8e6e5207fdbd5cae4.r72.stream.cf1.rackcdn.com",
              "name"=>"fogcontainertests", "cdn_uri"=>"http://0115a9de56617a5d5473-cf33674d895dc8b8e6e5207fdbd5cae4.r72.cf1.rackcdn.com",
              "cdn_ssl_uri"=>"https://a5df8bd8a418ca88061e-cf33674d895dc8b8e6e5207fdbd5cae4.ssl.cf1.rackcdn.com"
            }
          ]
          response
        end
      end
    end
  end
end
