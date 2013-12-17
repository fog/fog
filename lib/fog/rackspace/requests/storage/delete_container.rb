module Fog
  module Storage
    class Rackspace

      class Real

        # Delete an existing container
        #
        # ==== Parameters
        # * name<~String> - Name of container to delete
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def delete_container(name)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => Fog::Rackspace.escape(name)
          )
        end

      end

      class Mock
        def delete_container(name)
          escaped = Fog::Rackspace.escape(name)
          container = data[escaped]

          if container.nil?
            raise Fog::Storage::Rackspace::NotFound.new
          end

          if !container.empty?
            raise Excon::Errors::Conflict.new 'Conflict'
          end

          data.delete escaped

          response = Excon::Response.new
          response.status = 204
          response
        end
      end

    end
  end
end
