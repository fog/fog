module Fog
  module Storage
    class HP
      class Real
        # Get details for a shared object
        #
        # ==== Parameters
        # * shared_object_url<~String> - Url of the shared object
        #
        def get_shared_object(shared_object_url, &block)
          # split up the shared object url
          uri = URI.parse(shared_object_url)
          path   = uri.path

          if block_given?
            response = shared_request(
              :response_block  => block,
              :expects  => 200,
              :method   => 'GET',
              :path     => path
            )
          else
            response = shared_request({
              :expects  => 200,
              :method   => 'GET',
              :path     => path
            }, false, &block)
          end
          response
        end
      end

      class Mock # :nodoc:all
        def get_shared_object(shared_object_url, &block)
          response = Excon::Response.new
          response.status = 200
          response.headers = {
            'Last-Modified'            => Date.today.rfc822,
            'Etag'                     => Fog::HP::Mock.etag,
            'Accept-Ranges'            => 'bytes',
            'Content-Type'             => "text/plain",
            'Content-Length'           => 11,
            'X-Trans-Id'               => "tx#{Fog::Mock.random_hex(32)}"
          }
          unless block_given?
            response.body = "This is a sample text.\n"
          else
            data = StringIO.new("This is a sample text.\n")
            remaining = data.length
            while remaining > 0
              chunk = data.read([remaining, Excon::CHUNK_SIZE].min)
              block.call(chunk)
              remaining -= Excon::CHUNK_SIZE
            end
          end
          response
        end
      end
    end
  end
end
