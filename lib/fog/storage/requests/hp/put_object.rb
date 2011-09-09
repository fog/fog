module Fog
  module HP
    class Storage
      class Real

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_object(container, object, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          if headers.has_key?('Transfer-Encoding')
            headers.delete('Content-Length')
          end
          response = request(
            :body     => data[:body],
            :expects  => 201,
            :headers  => headers,
            :method   => 'PUT',
            :path     => "#{escape_name(container)}/#{escape_name(object)}"
          )
          response
        end

      end

      class Mock # :nodoc:all

        def put_object(container_name, object_name, data, options = {})
          ### Take care of case of copy operation
          if source = options['X-Copy-From'] && data.nil?
            # split source container and object
            # dup object into target object
          else
            data = Fog::Storage.parse_data(data)
            unless data[:body].is_a?(String)
              data[:body] = data[:body].read
            end
          end
          response = Excon::Response.new
          if (container = self.data[:containers][container_name])
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

            container[:objects][object_name] = object
            response.headers = {
              'Content-Length'  => object['Content-Length'],
              'Content-Type'    => object['Content-Type'],
              'ETag'            => object['ETag'],
              'Date'            => object['Date']
            }
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 201}, response))
          end
          response
        end

      end

    end
  end
end
