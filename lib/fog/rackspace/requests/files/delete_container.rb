unless Fog.mocking?

  module Fog
    module Rackspace
      class Files

        # Delete an existing container
        #
        # ==== Parameters
        # * name<~String> - Name of container to delete
        #
        def delete_container(name)
          response = storage_request(
            :expects  => 204,
            :method   => 'DELETE',
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

        def delete_container(name)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end

end
