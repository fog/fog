module Fog
  module Storage
    class Rackspace
      class Real

        # Get details for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def get_object(container, object, &block)
          params = {
            :expects  => 200,
            :method   => 'GET',
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          }

          if block_given?
            params[:response_block] = block
          end

          request(params, false)
        end

      end
    end
  end
end
