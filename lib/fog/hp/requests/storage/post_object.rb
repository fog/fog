module Fog
  module Storage
    class HP
      class Real

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
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
          ### Take care of case of copy operation
          source = headers['X-Copy-From']
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
          response
        end

      end

    end
  end
end
