module Fog
  module Storage
    class Rackspace

      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def put_container(name, options={})
          request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :headers => options,
            :path     => Fog::Rackspace.escape(name)
          )
        end

      end

      class Mock
        def put_container(name, options={})
          escaped = Fog::Rackspace.escape(name)

          container = MockContainer.new
          options.keys.each do |k|
            container.meta[k] = options[k] if k =~ /^X-Container-Meta/
          end
          data[escaped] = container

          response = Excon::Response.new
          if data.has_key?(escaped)
            response.status = 202 # Accepted
          else
            response.status = 201 # Created
          end
          response
        end
      end

    end
  end
end
