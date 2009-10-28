unless Fog.mocking?

  module Fog
    module Rackspace
      class Files

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name)
          response = storage_request(
            :expects  => 201,
            :method   => 'PUT',
            :path     => CGI.escape(name)
          )
          response
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def put_container
        end

      end
    end
  end

end
