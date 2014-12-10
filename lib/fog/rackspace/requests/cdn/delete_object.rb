module Fog
  module CDN
    class Rackspace
      class Real
        # Delete an existing object
        #
        # ==== Parameters
        # * container<~String> - Name of container to delete
        # * object<~String> - Name of object to delete
        # @return [Excon::Response] response
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
          response = Excon::Response.new
          response.status = 204
          response.headers = {
            "Content-Length"=>"0",
            "Date"=>"Fri, 01 Feb 2013 21:34:33 GMT",
            "X-Trans-Id"=>"tx860f26bd76284a849384c0a467767b57"
          }
          response.body = ""
          response
        end
      end
    end
  end
end
