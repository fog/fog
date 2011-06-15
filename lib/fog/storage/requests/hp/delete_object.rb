module Fog
  module HP
    class Storage
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
            :path     => "#{URI.escape(container)}/#{URI.escape(object)}"
          )
          response
        end

      end
    end
  end
end
