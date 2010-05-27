module Fog
  module Rackspace
    module Files
      class Real

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

      class Mock

        def delete_container(name)
          raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
