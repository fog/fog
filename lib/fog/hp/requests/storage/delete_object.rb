module Fog
  module Storage
    class HP
      class Real
        # Delete an existing object
        #
        # ==== Parameters
        # * container<~String> - Name of container to delete
        # * object<~String> - Name of object to delete
        #
        def delete_object(container, object)
          response = request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "#{Fog::HP.escape(container)}/#{Fog::HP.escape(object)}"
          )
          response
        end
      end

      class Mock # :nodoc:all
        def delete_object(container_name, object_name, options = {})
          response = Excon::Response.new
          if container = self.data[:containers][container_name]
            if (object = container[:objects][object_name])
              response.status = 204
              container[:objects].delete(object_name)
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
