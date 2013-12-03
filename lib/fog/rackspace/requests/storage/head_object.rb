module Fog
  module Storage
    class Rackspace
      class Real

        # Get headers for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def head_object(container, object)
          request({
            :expects  => 200,
            :method   => 'HEAD',
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          }, false)
        end

      end
    end
  end
end
