module Fog
  module Storage
    class HP
      class Real
        # Create a new object in a shared container
        #
        # ==== Parameters
        # * shared_container_url<~String> - Shared url for the container
        # * object<~String> - Name of the object
        # * options<~Hash> - header options
        #
        def put_shared_object(shared_container_url, object_name, data, options = {}, &block)
          # split up the shared object url
          uri = URI.parse(shared_container_url)
          path   = uri.path

          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          if block_given?
            headers['Transfer-Encoding'] = 'chunked'
            headers.delete('Content-Length')
            return shared_request(
              :request_block     => block,
              :expects  => 201,
              :headers  => headers,
              :method   => 'PUT',
              :path     => "#{path}/#{Fog::HP.escape(object_name)}"
            )
          end
          if headers.key?('Transfer-Encoding')
            headers.delete('Content-Length')
          end
          response = shared_request(
            :body     => data[:body],
            :expects  => 201,
            :headers  => headers,
            :method   => 'PUT',
            :path     => "#{path}/#{Fog::HP.escape(object_name)}"
          )
          response
        end
      end

      class Mock # :nodoc:all
        def put_shared_object(shared_container_url, object_name, data, options = {}, &block)
          response = Excon::Response.new
          data = Fog::Storage.parse_data(data)
          unless data[:body].is_a?(String)
            data[:body] = data[:body].read
          end
          response.status = 201
          object = {
            :body             => data[:body],
            'Content-Type'    => options['Content-Type'] || data[:headers]['Content-Type'],
            'ETag'            => Fog::HP::Mock.etag,
            'Key'             => object_name,
            'Date'            => Fog::Time.now.to_date_header,
            'Content-Length'  => options['Content-Length'] || data[:headers]['Content-Length'],
          }

          for key, value in options
            case key
            when 'Cache-Control', 'Content-Disposition', 'Content-Encoding', 'Content-MD5', 'Expires', /^X-Object-Meta-/
              object[key] = value
            end
          end

          response.headers = {
            'Content-Length'  => object['Content-Length'],
            'Content-Type'    => object['Content-Type'],
            'ETag'            => object['ETag'],
            'Date'            => object['Date']
          }

          response
        end
      end
    end
  end
end
