module Fog
  module Storage
    class Rackspace
      class Real

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # * object<~String> - Name for object
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        def put_object_manifest(container, object)
          path = "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          request(
            :expects  => 201,
            :headers  => {'X-Object-Manifest' => path},
            :method   => 'PUT',
            :path     => path
          )
        end

      end
    end
  end
end
