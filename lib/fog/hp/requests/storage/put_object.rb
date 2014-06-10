module Fog
  module Storage
    class HP
      class Real
        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_object(container, object, data, options = {}, &block)
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          if block_given?
            headers['Transfer-Encoding'] = 'chunked'
            headers.delete('Content-Length')
            return request(
              :request_block     => block,
              :expects  => 201,
              :headers  => headers,
              :method   => 'PUT',
              :path     => "#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
            )
          end
          if headers.key?('Transfer-Encoding')
            headers.delete('Content-Length')
          end
          response = request(
            :body     => data[:body],
            :expects  => 201,
            :headers  => headers,
            :method   => 'PUT',
            :path     => "#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
          )
          response
        end
      end

      class Mock # :nodoc:all
        def put_object(container_name, object_name, data, options = {})
          response = Excon::Response.new
          ### Take care of case of copy operation
          source = options['X-Copy-From']
          if (source && data.nil?)
            # split source container and object
            _, source_container_name, source_object_name = source.split('/')
            # dup object into target object
            source_container = self.data[:containers][source_container_name]
            container = self.data[:containers][container_name]
            if (source_container && container)
              response.status = 201
              source_object = source_container[:objects][source_object_name]
              target_object = source_object.dup
              target_object.merge!({
                'Key'    => object_name,
                'Date'   => Fog::Time.now.to_date_header
              })
              container[:objects][object_name] = target_object
            else
              raise Fog::Storage::HP::NotFound
            end
          else
            data = Fog::Storage.parse_data(data)
            unless data[:body].is_a?(String)
              data[:body] = data[:body].read
            end
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
              raise Fog::Storage::HP::NotFound
            end
          end
          response
        end
      end
    end
  end
end
