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

      class Mock
        def delete_object(container, object)
          escaped_container = Fog::Rackspace.escape(container)
          escaped_object = Fog::Rackspace.escape(object)

          c = self.data[escaped_container]
          raise Fog::Storage::Rackspace::NotFound.new if c.nil?

          raise Fog::Storage::Rackspace::NotFound.new unless c.objects.has_key? escaped_object

          c.objects.delete escaped_object

          response = Excon::Response.new
          response.status = 204
          response
        end
      end

    end
  end
end
