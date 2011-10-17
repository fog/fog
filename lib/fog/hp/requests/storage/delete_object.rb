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
            :path     => "#{escape_name(container)}/#{escape_name(object)}"
          )
          response
        end

      end

      class Mock # :nodoc:all

        def delete_object(container_name, object_name, options = {})
          response = Excon::Response.new
          if container = self.data[:containers][container_name]
            response.status = 204
            container[:objects].delete(object_name)
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 204}, response))
          end
          response
        end

      end

    end
  end
end
