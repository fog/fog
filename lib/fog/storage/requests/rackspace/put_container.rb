module Fog
  module Rackspace
    class Storage
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name)
          response = request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :path     => URI.escape(name)
          )
          response
        end

      end
    end
  end
end
