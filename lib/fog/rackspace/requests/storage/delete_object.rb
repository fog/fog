module Fog
  module Storage
    class Rackspace
      class Real

        # Delete an existing object
        #
        # ==== Parameters
        # * container<~String> - Name of container to delete
        # * object<~String> - Name of object to delete
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def delete_object(container, object)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          )
        end

      end
    end
  end
end
