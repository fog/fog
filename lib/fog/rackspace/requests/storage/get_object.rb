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

      class Mock
        def get_object(container, object, &block)
          c = mock_container! container
          o = c.mock_object! object

          body, size = "", 0

          o.each_part do |part|
            body << part.body
            size += part.bytes_used
          end

          if block_given?
            # Just send it all in one chunk.
            block.call(body, 0, size)
          end

          response = Excon::Response.new
          response.body = body
          response.headers = o.to_headers
          response
        end
      end
    end
  end
end
