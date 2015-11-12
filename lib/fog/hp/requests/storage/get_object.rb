module Fog
  module Storage
    class HP
      class Real
        # Get details for an object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def get_object(container, object, options = {}, &block)
          if block_given?
            response = request(
              :response_block  => block,
              :expects  => [200, 206],
              :headers  => options,
              :method   => 'GET',
              :path     => "#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
            )
          else
            response = request({
              :expects  => [200, 206],
              :headers  => options,
              :method   => 'GET',
              :path     => "#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
            }, false, &block)
          end
          response
        end
      end

      class Mock # :nodoc:all
        def get_object(container_name, object_name, options = {}, &block)
          unless container_name
            raise ArgumentError.new('container_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          response = Excon::Response.new
          if (container = self.data[:containers][container_name])
            if (object = container[:objects][object_name])
              if options['If-Match'] && options['If-Match'] != object['ETag']
                response.status = 412
              elsif options['If-Modified-Since'] && options['If-Modified-Since'] >= Time.parse(object['Last-Modified'])
                response.status = 304
              elsif options['If-None-Match'] && options['If-None-Match'] == object['ETag']
                response.status = 304
              elsif options['If-Unmodified-Since'] && options['If-Unmodified-Since'] < Time.parse(object['Last-Modified'])
                response.status = 412
              else
                response.status = 200
                for key, value in object
                  case key
                  when 'Cache-Control', 'Content-Disposition', 'Content-Encoding', 'Content-Length', 'Content-MD5', 'Content-Type', 'ETag', 'Expires', 'Last-Modified', /^X-Object-Meta-/
                    response.headers[key] = value
                  end
                end
                unless block_given?
                  response.body = object[:body]
                else
                  data = StringIO.new(object[:body])
                  remaining = data.length
                  while remaining > 0
                    chunk = data.read([remaining, Excon::CHUNK_SIZE].min)
                    block.call(chunk)
                    remaining -= Excon::CHUNK_SIZE
                  end
                end
              end
            else
              raise Fog::Storage::HP::NotFound
            end
          else
            raise Fog::Storage::HP::NotFound
          end
          response
        end
      end
    end
  end
end
