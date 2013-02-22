module Fog
  module Storage
    class Rackspace
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name, options={})
          request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :headers => options,
            :path     => Fog::Rackspace.escape(name)
          )
        end

      end
    end
  end
end
