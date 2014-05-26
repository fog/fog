module Fog
  module Storage
    class HP
      class Real
        # Create or update metadata for an existing object
        #
        # ==== Parameters
        # * container<~String> - Name of the existing container, should be < 256 bytes and must not contain '/'
        # * object<~String> - Name of the existing object
        # * headers<~Hash> - Hash of metadata name/value pairs
        def post_object(container, object, headers = {})
          response = request(
            :expects  => 202,
            :headers  => headers,
            :method   => 'POST',
            :path     => "#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
          )
          response
        end
      end

      class Mock # :nodoc:all
        def post_object(container_name, object_name, headers = {})
          response = Excon::Response.new
          if container = self.data[:containers][container_name]
            response.status = 202
            object = container[:objects][object_name]

            for key, value in headers
              case key
              when 'Content-Disposition', 'Content-Encoding', 'X-Delete-At', 'X-Delete-After', /^X-Object-Meta-/
                object[key] = value unless value.nil?
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
          response
        end
      end
    end
  end
end
