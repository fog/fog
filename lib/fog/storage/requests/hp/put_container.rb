module Fog
  module HP
    class Storage
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name, options = {})
          response = request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'PUT',
            :path     => URI.escape(name)
          )
          response
        end

      end
    end
  end
end
