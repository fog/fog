module Fog
  module Rackspace
    module Files
      class Real

        # Delete an existing container
        #
        # ==== Parameters
        # * container<~String> - Name of container to delete
        # * object<~String> - Name of object to delete
        #
        def delete_object(container, object)
          response = storage_request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "#{CGI.escape(container)}/#{CGI.escape(object)}"
          )
          response
        end

      end

      class Mock

        def delete_object(container, object)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
