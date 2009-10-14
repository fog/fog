unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Delete an existing server
        #
        # ==== Parameters
        # * id<~Integer> - Id of server to delete
        #
        def delete_server(id)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path   => "servers/#{id}"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def delete_server
        end

      end
    end
  end

end
