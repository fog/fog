unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Update an existing server
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * name<~String> - New name for server
        #   * adminPass<~String> - New admin password for server
        #
        def update_server(options = {})
          request(
            :body     => options.to_json,
            :expects  => 204,
            :method   => 'PUT',
            :path     => "servers/#{id}"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def update_server
        end

      end
    end
  end

end
