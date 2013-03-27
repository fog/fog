module Fog
  module Storage
    class Rackspace
      class Real

        # Get headers for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
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
