module Fog
  module Rackspace
    class Storage
      class Real

        # Delete an existing container
        #
        # ==== Parameters
        # * name<~String> - Name of container to delete
        #
        def delete_container(name)
          response = request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => URI.escape(name)
          )
          response
        end

      end
    end
  end
end
