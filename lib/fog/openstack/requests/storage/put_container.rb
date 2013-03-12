module Fog
  module Storage
    class OpenStack
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name)
          request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :path     => Fog::OpenStack.escape(name)
          )
        end

      end
    end
  end
end
