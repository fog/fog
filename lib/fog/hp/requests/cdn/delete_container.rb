module Fog
  module CDN
    class HP
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
            :path     => CGI.escape(name)
          )
          response
        end

      end
    end
  end
end